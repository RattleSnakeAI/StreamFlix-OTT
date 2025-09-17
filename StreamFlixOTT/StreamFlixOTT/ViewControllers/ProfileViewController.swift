import Foundation
import UIKit

enum ProfileAction {
    case myProfile
    case myList
    case watchHistory
    case downloads
    case settings
    case help
    case signOut
}

// MARK: - Profile View Controller
class ProfileViewController: UIViewController {
    private let tableView = UITableView()
    
    private let profileItems: [(String, String, String, ProfileAction)] = [
        ("person.circle.fill", "My Profile", "Manage your account", .myProfile),
        ("heart.fill", "My List", "15 items", .myList),
        ("clock.fill", "Watch History", "Last 30 days", .watchHistory),
        ("arrow.down.circle.fill", "Downloads", "", .downloads),
        ("gearshape.fill", "Settings", "Account & Privacy", .settings),
        ("questionmark.circle.fill", "Help & Support", "FAQs & Contact", .help),
        ("arrow.right.square.fill", "Sign Out", "", .signOut)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Profile"
        // Create a new appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // ensures no translucency
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Apply appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white  // button items
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        
        tableView.backgroundColor = .black
        tableView.separatorColor = .darkGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        let item = profileItems[indexPath.row]
        
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .gray
        cell.accessoryType = .disclosureIndicator
        
        cell.imageView?.image = UIImage(systemName: item.0)
        cell.imageView?.tintColor = .red
        cell.textLabel?.text = item.1
        cell.detailTextLabel?.text = item.2.isEmpty ? nil : item.2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = profileItems[indexPath.row]
        
        switch item.3 { // action
        case .myProfile:
            let profileVC = UserProfileViewController()
            navigationController?.pushViewController(profileVC, animated: true)
            
        case .myList, .watchHistory:
            let myListVC = MyListViewController()
            navigationController?.pushViewController(myListVC, animated: true)
        
        case .downloads:
            let downloadsVC = DownloadsViewController()
            navigationController?.pushViewController(downloadsVC, animated: true)
            
        case .settings:
            let settingsVC = SettingsViewController()
            navigationController?.pushViewController(settingsVC, animated: true)
            
        case .help:
            let helpVC = HelpViewController()
            navigationController?.pushViewController(helpVC, animated: true)
            
        case .signOut:
            handleSignOut()
        }
    }

}

extension ProfileViewController {
    func handleSignOut() {
        // Clear any saved user session (optional)
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        
        // Create Login screen
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        
        // Replace the window's rootViewController
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
        
        print("✅ User signed out and redirected to Login screen")
    }
}

