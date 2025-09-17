import UIKit

class DownloadTableViewCell: UITableViewCell {
    
    private let cardView = UIView()
    private let thumbnailImageView = UIImageView()
    private let gradientLayer = CAGradientLayer()
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Card container
        cardView.backgroundColor = .darkGray
        cardView.layer.cornerRadius = 12
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        // Thumbnail
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(thumbnailImageView)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])
        
        // Gradient overlay
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        gradientLayer.locations = [0.5, 1.0]
        thumbnailImageView.layer.addSublayer(gradientLayer)
        
        // Title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)
        
        // Details
        detailsLabel.font = UIFont.systemFont(ofSize: 14)
        detailsLabel.textColor = .lightGray
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(detailsLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: detailsLabel.topAnchor, constant: -4),
            
            detailsLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            detailsLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            detailsLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = thumbnailImageView.bounds
    }
    
    func configure(with movie: MovieEntity) {
        // Title
        titleLabel.text = movie.title ?? "Unknown Title"
        
        // Duration + File size
        var details = ""
        if let duration = movie.duration {
            details += duration
        }
        if let path = movie.localPath {
            let fileSize = getFileSize(at: path)
            details += details.isEmpty ? "\(fileSize)" : " • \(fileSize)"
        }
        detailsLabel.text = details
        
        // MARK: No network request is needed Works online and offline.
        if let imageData = movie.thumbnail {
            thumbnailImageView.image = UIImage(data: imageData)
        } else {
            thumbnailImageView.image = UIImage(systemName: "photo") // placeholder
        }
    }
    
    private func getFileSize(at fileName: String) -> String {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documents.appendingPathComponent(fileName) // ✅ correct full path
        
        do {
            let attrs = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            if let size = attrs[.size] as? Int64 {
                let mb = Double(size) / (1024 * 1024)
                return String(format: "%.1f MB", mb)
            }
        } catch {
            print("❌ Failed to get file size:", error.localizedDescription)
        }
        return "Unknown Size"
    }

}

