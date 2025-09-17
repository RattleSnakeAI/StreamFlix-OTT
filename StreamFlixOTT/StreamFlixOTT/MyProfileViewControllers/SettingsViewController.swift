import Foundation
import UIKit

// MARK: - Settings VC
class SettingsViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // Define settings items (icon, title, subtitle)
    private let settings: [[(String, String, String)]] = [
        // Section 1 - Account
        [
            ("person.crop.circle", "Change Password", "Update your login credentials"),
            ("creditcard.fill", "Manage Subscription", "Upgrade or cancel your plan")
        ],
        
        // Section 2 - Preferences
        [
            ("bell.fill", "Notifications", "Control push alerts"),
            ("arrow.down.circle.fill", "Download Settings", "Wi-Fi only, storage, etc.")
        ],
        
        // Section 3 - App Info
        [
            ("info.circle.fill", "About", "Version 1.0.0"),
            ("hand.raised.fill", "Privacy Policy", "Read how we protect your data"),
            ("doc.text.fill", "Terms of Service", "Legal agreements")
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - TableView DataSource & Delegate
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        let item = settings[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = item.1
        cell.detailTextLabel?.text = item.2
        cell.imageView?.image = UIImage(systemName: item.0)
        cell.imageView?.tintColor = .systemBlue
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.numberOfLines = 1
        cell.detailTextLabel?.numberOfLines = 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = settings[indexPath.section][indexPath.row]
        
        switch item.1 {
        case "Change Password":
            showAlert(title: "Change Password", message: "Navigate to password reset flow.")
            
        case "Manage Subscription":
            showAlert(title: "Manage Subscription", message: "Navigate to subscription screen.")
            
        case "Notifications":
            showAlert(title: "Notifications", message: "Toggle notification preferences.")
            
        case "Download Settings":
            showAlert(title: "Download Settings", message: "Manage offline downloads.")
            
        case "About":
            showAlert(title: "About StreamFlix", message: "Version 1.0.0\nStreamFlix OTT App")
            
        case "Privacy Policy":
            showAlert(title: "Privacy Policy", message: "Open privacy policy page.")
            
        case "Terms of Service":
            showAlert(title: "Terms of Service", message: "Open terms of service page.")
            
        default:
            break
        }
    }
    
    // MARK: - Helper Alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
