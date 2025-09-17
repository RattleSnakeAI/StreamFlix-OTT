import Foundation
import UIKit

final class AlertManager {
    
    static let shared = AlertManager()
    private init() {} // Prevent instantiation from outside
    
    /// Show alert with Cancel and Subscribe buttons
    /// - Parameters:
    ///   - viewController: The VC where the alert will be presented
    ///   - title: Alert title
    ///   - message: Alert description
    ///   - cancelTitle: Cancel button title (default: "Cancel")
    ///   - subscribeTitle: Subscribe button title (default: "Subscribe")
    ///   - subscribeHandler: Closure called when Subscribe tapped
    func showAlert(
        on viewController: UIViewController,
        title: String,
        message: String,
        cancelTitle: String = "Cancel",
        subscribeTitle: String = "Subscribe",
        subscribeHandler: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Cancel action
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        alertController.addAction(cancelAction)
        
        // Subscribe action
        let subscribeAction = UIAlertAction(title: subscribeTitle, style: .default) { _ in
            subscribeHandler?()
        }
        alertController.addAction(subscribeAction)
        
        // Present alert
        viewController.present(alertController, animated: true, completion: nil)
    }
}

