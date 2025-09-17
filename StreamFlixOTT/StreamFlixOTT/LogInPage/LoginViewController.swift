import Foundation
import UIKit
import CoreData

class LoginViewController : UIViewController {
    
    // MARK: - UI Elements
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "StreamFlix") // Add your background image to assets
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let signupButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleNetworkChange(_:)),
                name: .networkStatusChanged,
                object: nil
            )
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let stack = UIStackView(arrangedSubviews: [usernameTextField, passwordTextField, loginButton, signupButton])
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    // MARK: - Actions
    @objc private func handleLogin() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter username and password.")
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        do {
            let results = try context.fetch(request)
            if results.isEmpty {
                showAlert(message: "Invalid credentials. Please sign up if new user.")
            } else {
                // Navigate to next screen
                DispatchQueue.global().async {
                    // some background work
                    NetworkMonitor.shared.getInitialStatus { isConnected in
                        print("✅ Initial status: \(isConnected ? "Online" : "Offline")")
                        
                        DispatchQueue.main.async {
                            if isConnected {
                                print(" Online: fetch online content")
                                let secondVC = MainTabBarController(initialTabIndex: 0, isOfflineMode: false)
                                self.navigationController?.pushViewController(secondVC, animated: true)
                            } else {
                                print("📴 Offline: Show downloads")
                                let downloadsVC = MainTabBarController(initialTabIndex: 3, isOfflineMode: true)
                                self.navigationController?.pushViewController(downloadsVC, animated: true)
                            }
                        }
                    }
                }
            }
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
        }
    }
    
    @objc private func handleSignup() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter username and password.")
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Check if user exists
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let existingUsers = try context.fetch(request)
            if !existingUsers.isEmpty {
                showAlert(message: "Username already exists. Try a different one.")
                return
            }
            
            let newUser = UserEntity(context: context)
            newUser.username = username
            newUser.password = password
            
            try context.save()
            showAlert(title: "Success", message: "Account created successfully! Please login.")
            
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers
    private func showAlert(title: String = "Alert", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension LoginViewController {
    // MARK: Closue call handleNetworkChange
    @objc private func handleNetworkChange(_ notification: Notification) {
        if let isConnected = notification.userInfo?["isConnected"] as? Bool {
            print("📡 Global listener: \(isConnected ? "Online" : "Offline")")
            if !isConnected {
                // Show offline banner or switch to downloads tab
                let downloadsVC = MainTabBarController(initialTabIndex: 3, isOfflineMode: true)
                self.navigationController?.pushViewController(downloadsVC, animated: true)
            }
        }
    }
}
