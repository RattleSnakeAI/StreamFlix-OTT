import Foundation
import UIKit


// MARK: - Featured Banner Cell
class FeaturedBannerCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let gradientLayer = CAGradientLayer()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let playButton = UIButton(type: .system)
    private let myListButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageView.bounds
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = UIColor.darkGray
        imageView.isUserInteractionEnabled = false
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        gradientLayer.locations = [0.3, 1.0]
        imageView.layer.addSublayer(gradientLayer)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        descriptionLabel.numberOfLines = 3
        
        playButton.setTitle("▶ Play", for: .normal)
        playButton.setTitleColor(.white, for: .normal)
        playButton.backgroundColor = UIColor.systemRed
        playButton.layer.cornerRadius = 8
        playButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        myListButton.setTitle("+ My List", for: .normal)
        myListButton.setTitleColor(.white, for: .normal)
        myListButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        myListButton.layer.cornerRadius = 8
        myListButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        [imageView, titleLabel, descriptionLabel, playButton, myListButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -16),
            
            playButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            playButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            playButton.widthAnchor.constraint(equalToConstant: 100),
            playButton.heightAnchor.constraint(equalToConstant: 40),
            
            myListButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 12),
            myListButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            myListButton.widthAnchor.constraint(equalToConstant: 100),
            myListButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        descriptionLabel.text = movie.description
        
        ImageCacheManager.shared.loadImage(from: movie.imageURL) { [weak self] image in
            self?.imageView.image = image
        }
    }
}
