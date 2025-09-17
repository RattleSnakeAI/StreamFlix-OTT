import Foundation
import UIKit


// MARK: - Search View Controller
class SearchViewController: UIViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private var collectionView: UICollectionView!
    private let dataManager = StreamingDataManager.shared
    private let videoManager = PlayerViewController.shared
    
    private var searchResults: (movies: [Movie], shows: [TVShow]) = ([], [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Search"
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
        
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (view.frame.width - 60) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.register(TVShowCollectionViewCell.self, forCellWithReuseIdentifier: "ShowCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Show all content initially
        searchResults = (movies: dataManager.allMovies, shows: dataManager.allShows)
    }
    
    private func  setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies and shows..."
        searchController.searchBar.tintColor = .red
        searchController.searchBar.barTintColor = .black
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText.isEmpty {
            searchResults = (movies: dataManager.allMovies, shows: dataManager.allShows)
        } else {
            searchResults = dataManager.searchContent(query: searchText)
        }
        
        collectionView.reloadData()
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.movies.count + searchResults.shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < searchResults.movies.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
            cell.configure(with: searchResults.movies[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as! TVShowCollectionViewCell
            let showIndex = indexPath.item - searchResults.movies.count
            cell.configure(with: searchResults.shows[showIndex])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < searchResults.movies.count {
            let movie = searchResults.movies[indexPath.item]
            print("Selected movie: \(movie.title)")
            videoManager.playVideo(from: movie)
        } else {
            let showIndex = indexPath.item - searchResults.movies.count
            let show = searchResults.shows[showIndex]
            print("Selected show: \(show.title)")
            videoManager.playVideo(from: show)
        }
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
