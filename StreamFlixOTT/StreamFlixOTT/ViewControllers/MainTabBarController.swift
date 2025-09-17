import Foundation
import UIKit


// MARK: - Main Tab Bar Controller
class MainTabBarController: UITabBarController {
    
    private var initialTabIndex: Int = 0   // default Home
    private var isOfflineMode: Bool = false
    
    init(initialTabIndex: Int = 0, isOfflineMode: Bool = false) {
        self.initialTabIndex = initialTabIndex
        self.isOfflineMode = isOfflineMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
        
        // 🔹 Add observer for global network changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNetworkChange(_:)),
            name: .networkStatusChanged,
            object: nil
        )
        // 👇 set the selected tab
        self.selectedIndex = initialTabIndex
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            
            // Left button
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Close",
                style: .plain,
                target: self,
                action: #selector(closeTapped)
            )
    }
    
    @objc func closeTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupTabBar() {
        if #available(iOS 13.0, *) {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground() // removes translucency
                appearance.backgroundColor = .black          // solid black
                appearance.stackedLayoutAppearance.normal.iconColor = .gray
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
                appearance.stackedLayoutAppearance.selected.iconColor = .red
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.red]

                tabBar.standardAppearance = appearance
                tabBar.scrollEdgeAppearance = appearance // for iOS 15+ when using scrollable content
            } else {
                // Fallback for iOS 12 and below
                tabBar.barTintColor = .black
                tabBar.tintColor = .red
                tabBar.unselectedItemTintColor = .gray
                tabBar.isTranslucent = false
            }
    }
    
    private func setupViewControllers() {
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let moviesVC = MoviesViewController()
        let moviesNav = UINavigationController(rootViewController: moviesVC)
        moviesNav.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film.fill"), tag: 1)
        
        let searchVC = SearchViewController()
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        
        let showsVC = TVShowsViewController()
        let showsNav = UINavigationController(rootViewController: showsVC)
        showsNav.tabBarItem = UITabBarItem(title: "TV Shows", image: UIImage(systemName: "tv.fill"), tag: 3)
        
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 4)
        
        viewControllers = [homeNav, moviesNav, searchNav, showsNav, profileNav]
    }
}


// MARK: Handle network change
extension MainTabBarController {
    
    @objc private func handleNetworkChange(_ notification: Notification) {
        guard let isConnected = notification.userInfo?["isConnected"] as? Bool else { return }
        
        if isConnected {
            print("✅ Online: Stay on current tab")
        } else {
            print("📴 Offline: Switching to Downloads tab")
            DispatchQueue.main.async {
                let downloadsVC = DownloadsViewController()
                self.navigationController?.pushViewController(downloadsVC, animated: true)
            }
        }
    }
}
