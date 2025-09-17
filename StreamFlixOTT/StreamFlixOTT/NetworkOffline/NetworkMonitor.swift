import Foundation
import Network


extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}


class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private(set) var isConnected: Bool = false
    private var hasReceivedFirstUpdate = false
    
    // 🔹 NEW: for continuous updates
       var statusChanged: ((Bool) -> Void)?
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = path.status == .satisfied
            print("🌐 Network status changed: \(self.isConnected ? "Online" : "Offline")")
            
            // notify continuous listeners
            DispatchQueue.main.async {
                // 🔹 1. Fire closure callback
                self.statusChanged?(self.isConnected)
                
                // 🔹 2. Post notification for global listeners
                NotificationCenter.default.post(
                    name: .networkStatusChanged,
                    object: nil,
                    userInfo: ["isConnected": self.isConnected]
                )
            }
            
            // Notify only once for the very first status
            if !self.hasReceivedFirstUpdate {
                self.hasReceivedFirstUpdate = true
                self.firstStatusHandler?(self.isConnected)
                self.firstStatusHandler = nil // clear handler after first use
            }
        }
        monitor.start(queue: queue)
    }
    
    // Completion for first status
    private var firstStatusHandler: ((Bool) -> Void)?
    
    func getInitialStatus(completion: @escaping (Bool) -> Void) {
        if hasReceivedFirstUpdate {
            completion(isConnected)  // already known
        } else {
            firstStatusHandler = completion // wait until first update arrives
        }
    }
}
