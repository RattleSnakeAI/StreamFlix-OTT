import UIKit
import AVKit
import AVFoundation
import CoreData

struct LocalPlayable: Playable {
    var videoURL: String
    var imageURL: String
}

// MARK: - Helper to get the top visible view controller
extension UIApplication {
    class func topViewController(
        base: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow }) }
            .first?.rootViewController
    ) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

// MARK: - Player View Controller
class PlayerViewController: UIViewController {
    static let shared = PlayerViewController()
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // Play remote Playable (presenter optional; if nil -> fallback to topViewController())
    func playVideo(from movie: Playable, presenter: UIViewController? = nil) {
        // Ensure the videoURL is valid
           guard URL(string: movie.videoURL) != nil else {
               showAlert(message: "Invalid video URL", presenter: presenter)
               return
           }
           // Pass the Playable object itself to presentPlayer
           presentPlayer(from: presenter, with: movie)
    }
    
    // Play local MovieEntity (presenter optional)
    func playVideo(from movieEntity: MovieEntity, presenter: UIViewController? = nil) {
        guard let fileName = movieEntity.localPath else {
            showAlert(message: "Local file not found", presenter: presenter)
            return
        }
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documents.appendingPathComponent(fileName)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            showAlert(message: "File missing at: \(fileURL.path)", presenter: presenter)
            return
        }
        
        // Create a temporary Playable for local playback
        let localPlayable = LocalPlayable(
            videoURL: fileURL.absoluteString,
            imageURL: movieEntity.thumbnail.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        )
        presentPlayer(from: presenter, with: localPlayable)
    }
    
    // Present player: prefer explicit presenter, else fallback to UIApplication.topViewController()
    private func presentPlayer(from presenter: UIViewController?, with playable: Playable) {
        guard let url = URL(string: playable.videoURL) else {
            showAlert(message: "Invalid video URL", presenter: presenter)
            return
        }
        let player = AVPlayer(url: url)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        
        // Add Download button only for remote URLs
        if url.scheme?.hasPrefix("http") == true {
            let downloadButton = UIButton(type: .system)
            downloadButton.setTitle("⬇︎ Download", for: .normal)
            downloadButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            downloadButton.setTitleColor(.white, for: .normal)
            downloadButton.layer.cornerRadius = 8
            downloadButton.translatesAutoresizingMaskIntoConstraints = false
            downloadButton.addTarget(self, action: #selector(downloadTapped(_:)), for: .touchUpInside)
            
            if let overlay = playerVC.contentOverlayView {
                overlay.addSubview(downloadButton)
                NSLayoutConstraint.activate([
                    downloadButton.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -20),
                    downloadButton.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -60),
                    downloadButton.widthAnchor.constraint(equalToConstant: 120),
                    downloadButton.heightAnchor.constraint(equalToConstant: 40)
                ])
            }
            objc_setAssociatedObject(downloadButton, &AssociatedKeys.playableKey, playable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        // prefer explicit presenter, else fallback
        let presenterToUse = presenter ?? UIApplication.topViewController()
        guard let presenterVC = presenterToUse else {
            print("PlayerViewController: no presenter available to present playerVC")
            return
        }

        presenterVC.present(playerVC, animated: true) {
            player.play()
        }
    }
    
    // Download action (uses your helper)
    @objc private func downloadTapped(_ sender: UIButton) {
        
        guard let movie = objc_getAssociatedObject(sender, &AssociatedKeys.playableKey) as? Playable,
                  let url = URL(string: movie.videoURL),
                  let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
                return
            }
        
        DownloadVideoHelperClass.shared.downloadVideo(from: url, fileName: url.lastPathComponent) { localURL in
            guard let localURL = localURL else {
                DispatchQueue.main.async { self.showAlert(message: "Download failed.") }
                return
            }
            
            // 🔹 Fetch actual image data from the thumbnail URL
            let imageData: Data
            if let thumbnailURL = URL(string: movie.imageURL),
               let data = try? Data(contentsOf: thumbnailURL) {
                imageData = data  // successfully fetched
            } else {
                imageData = Data() // fallback to empty Data if fetch fails
            }
            
            DownloadVideoHelperClass.shared.saveMovieToCoreData(
                title: localURL.deletingPathExtension().lastPathComponent,
                description: "",
                localPath: localURL.lastPathComponent,
                duration: "",
                imageURl: imageData,
                rating: 0.0,
                releaseYear: 2025,
                category: "Downloaded",
                context: context
            )
            DispatchQueue.main.async { self.showAlert(title: "Success", message: "Downloaded successfully!") }
        }
    }
    
    private struct AssociatedKeys {
        static var playableKey = "playableKey"
    }
    
    // Alerts (presenter optional; falls back to topViewController)
    func showAlert(title: String? = "Error", message: String, presenter: UIViewController? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        let presenterToUse = presenter ?? UIApplication.topViewController()
        presenterToUse?.present(alert, animated: true)
    }
}
