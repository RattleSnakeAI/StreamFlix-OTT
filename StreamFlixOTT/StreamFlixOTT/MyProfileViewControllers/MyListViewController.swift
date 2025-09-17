import UIKit

class MyListViewController: UIViewController {
    
    private let dataManager = StreamingDataManager.shared
    private let videoManager = PlayerViewController.shared
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My List"
        view.backgroundColor = .black
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .black
        tableView.separatorColor = .darkGray
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        tableView.register(MyListCell.self, forCellReuseIdentifier: "MyListCell")
        
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

extension MyListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.mylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyListCell", for: indexPath) as? MyListCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let movie = dataManager.mylist[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.durationLabel.text = movie.duration
        
        ImageCacheManager.shared.loadImage(from: movie.imageURL) { image in
            cell.thumbnailImageView.image = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let myList = dataManager.mylist[indexPath.row]
        videoManager.playVideo(from: myList, presenter: self)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160  // instead of default ~44
    }
}
