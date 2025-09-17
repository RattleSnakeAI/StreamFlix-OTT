import UIKit
import CoreData
import AVKit

class DownloadsViewController: UIViewController {
    
    private let tableView = UITableView()
    private var downloadedMovies: [MovieEntity] = []
    
    private let videoManager = PlayerViewController.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchDownloadedMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Downloads"
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
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        tableView.register(DownloadTableViewCell.self, forCellReuseIdentifier: "DownloadCell")
        tableView.backgroundColor = .black
        tableView.separatorColor = .darkGray
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchDownloadedMovies() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        
        do {
            downloadedMovies = try context.fetch(request)
            if downloadedMovies.isEmpty {
                let emptyLabel = UILabel()
                emptyLabel.text = "No Downloads Yet"
                emptyLabel.textColor = .lightGray
                emptyLabel.textAlignment = .center
                emptyLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
                tableView.backgroundView = emptyLabel
            } else {
                tableView.backgroundView = nil
            }
            tableView.reloadData()
        } catch {
            print("❌ Failed to fetch movies:", error.localizedDescription)
        }
    }

}


extension DownloadsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = downloadedMovies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadCell", for: indexPath) as! DownloadTableViewCell
        cell.configure(with: movie)
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = downloadedMovies[indexPath.row]
        
        guard let path = movie.localPath else {
            print("❌ No local path for \(movie.title ?? "Unknown")")
            return
        }
        videoManager.playVideo(from: movie, presenter: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160  // instead of default ~44
    }
}
    

extension DownloadsViewController {
    
    // Enable swipe-to-delete
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            
            let movie = self.downloadedMovies[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // 1️⃣ Delete local file
            if let fileName = movie.localPath {
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documents.appendingPathComponent(fileName)
                
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        try FileManager.default.removeItem(at: fileURL)
                        print("✅ Deleted local file: \(fileURL.path)")
                    } catch {
                        print("❌ Failed to delete local file:", error.localizedDescription)
                    }
                }
            }
            
            // 2️⃣ Delete Core Data entry
            context.delete(movie)
            do {
                try context.save()
                print("✅ Deleted MovieEntity from Core Data")
                
                // 3️⃣ Update TableView
                self.downloadedMovies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            } catch {
                print("❌ Failed to delete from Core Data:", error.localizedDescription)
            }
            
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

