import Foundation
import UIKit

class HelpViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Help & Support"
        view.backgroundColor = .systemBackground
        setupUI()
        loadHelpContent()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            // ScrollView fills screen
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // StackView inside scrollView
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32) // keep proper width
        ])
    }
    
    // MARK: - Load Help Content
    private func loadHelpContent() {
        addSection(title: "Welcome to StreamFlix", content: """
        StreamFlix is your ultimate destination for movies, web series, and shows. Here, you can explore content, download your favorites, and enjoy them offline.
        """)
        
        addSection(title: "Frequently Asked Questions", content: """
        • How do I reset my password?
          Go to Login → Forgot Password and follow the instructions.

        • Can I download movies?
          Yes! Just tap the download button on any movie or series.

        • How many devices can I use?
          You can use StreamFlix on up to 3 devices simultaneously.
        """)
        
        addSection(title: "Subscription & Billing", content: """
        • Plans start at just $7.99/month.
        • Payments are processed securely via Apple Pay or Credit/Debit Cards.
        • You can cancel anytime under Settings → Subscription.
        """)
        
        addSection(title: "Customer Support", content: """
        • Email: support@streamflix.com
        • Phone: +1 (800) 123-4567
        • Live Chat: Available in the app from 9 AM – 9 PM.
        """)
        
        addSection(title: "Tips for Best Experience", content: """
        • Use Wi-Fi for faster downloads.
        • Keep your app updated to get the latest features.
        • Enable notifications to never miss new releases.
        """)
    }
    
    // MARK: - Helper to add sections
    private func addSection(title: String, content: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .systemBlue
        titleLabel.numberOfLines = 0
        
        let contentLabel = UILabel()
        contentLabel.text = content
        contentLabel.font = .systemFont(ofSize: 16)
        contentLabel.textColor = .label
        contentLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
    }
}
