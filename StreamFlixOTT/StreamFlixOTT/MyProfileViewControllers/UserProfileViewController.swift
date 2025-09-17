// MARK: - My Profile VC
import UIKit
import CoreData

class UserProfileViewController: UIViewController {
    
    // MARK: - UI Elements
    private let stackView = UIStackView()
    
    private let usernameLabel = UserProfileViewController.makeLabel(title: "Username: ")
    private let mobileLabel   = UserProfileViewController.makeLabel(title: "Mobile: ")
    private let addressLabel  = UserProfileViewController.makeLabel(title: "Address: ")
    private let passwordLabel = UserProfileViewController.makeLabel(title: "Password: ")
    
    private let editButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Edit Profile", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Profile"
        view.backgroundColor = .systemBackground
        setupUI()
        loadUserData()
        
        editButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        [usernameLabel, passwordLabel, mobileLabel, addressLabel, editButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Load User Data
    private func loadUserData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            if let user = try context.fetch(request).first {
                usernameLabel.text = "Username: \(user.username ?? "-")"
                passwordLabel.text = "Password: \(user.password ?? "-")"
                mobileLabel.text   = "Mobile: \(user.mobileNumber ?? "-")"
                addressLabel.text  = "Address: \(user.address ?? "-")"
            }
        } catch {
            print("❌ Failed to fetch user: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Actions
    @objc private func editProfileTapped() {
        // 👉 Navigate to an EditProfileViewController (optional)
//        let editVC = EditProfileViewController()
//        navigationController?.pushViewController(editVC, animated: true)
    }
    
    // MARK: - Helper
    private static func makeLabel(title: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = title
        lbl.font = .systemFont(ofSize: 18, weight: .medium)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }
}
