import Foundation
import UIKit

// MARK: - Home View Controller
class HomeViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var featuredCollectionView: UICollectionView!
    private var categoryCollectionViews: [UICollectionView] = []
    
    private let dataManager = StreamingDataManager.shared
    private let videoManager = PlayerViewController.shared
    private let localSaveVideo = DownloadVideoHelperClass.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        // ✅ Reload after setup to display data
        featuredCollectionView.reloadData()
        categoryCollectionViews.forEach { $0.reloadData() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "StreamFlix"
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
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        setupFeaturedSection()
        setupCategorySection()
    }
    
    private func setupFeaturedSection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width - 40, height: 300)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        featuredCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        featuredCollectionView.backgroundColor = .clear
        featuredCollectionView.showsHorizontalScrollIndicator = false
        featuredCollectionView.register(FeaturedBannerCell.self, forCellWithReuseIdentifier: "FeaturedCell")
        featuredCollectionView.dataSource = self
        featuredCollectionView.delegate = self
        featuredCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(featuredCollectionView)
        featuredCollectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func setupCategorySection() {
        for category in dataManager.categories {
            let categoryView = createCategoryView(for: category)
            stackView.addArrangedSubview(categoryView)
        }
    }
    
    private func createCategoryView(for category: ContentCategory) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = category.name
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.register(TVShowCollectionViewCell.self, forCellWithReuseIdentifier: "ShowCell")
        collectionView.tag = categoryCollectionViews.count
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        categoryCollectionViews.append(collectionView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        return containerView
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}


// MARK: - Collection View Data Source & Delegate Extensions
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == featuredCollectionView {
            return dataManager.featuredContent.count
        } else {
            let categoryIndex = collectionView.tag
            let category = dataManager.categories[categoryIndex]
            return category.movies.count + category.shows.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == featuredCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCell", for: indexPath) as! FeaturedBannerCell
            cell.configure(with: dataManager.featuredContent[indexPath.item])
            return cell
        } else {
            let categoryIndex = collectionView.tag
            let category = dataManager.categories[categoryIndex]
            
            if indexPath.item < category.movies.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
                cell.configure(with: category.movies[indexPath.item])
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as! TVShowCollectionViewCell
                let showIndex = indexPath.item - category.movies.count
                cell.configure(with: category.shows[showIndex])
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == featuredCollectionView {
            // ✅ Featured Section
            let featured = dataManager.featuredContent[indexPath.item]
            videoManager.playVideo(from: featured)
            
        } else {
            // ✅ Category Section
            let categoryIndex = collectionView.tag
            let category = dataManager.categories[categoryIndex]
            
            if indexPath.item < category.movies.count {
                // Movie tapped
                let movie = category.movies[indexPath.item]
                videoManager.playVideo(from: movie)
                
            } else {
                // Show tapped
                let showIndex = indexPath.item - category.movies.count
                let show = category.shows[showIndex]
                videoManager.playVideo(from: show)
            }
        }
    }
}



