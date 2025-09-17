import Foundation
import UIKit

//MARK: TVShowCollectionViewCell
class TVShowCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let seasonsLabel = UILabel()
    private let ratingLabel = UILabel()
    private let starImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = UIColor.darkGray
        imageView.isUserInteractionEnabled = false
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        
        seasonsLabel.font = UIFont.systemFont(ofSize: 10)
        seasonsLabel.textColor = .lightGray
        
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = .systemYellow
        
        ratingLabel.font = UIFont.systemFont(ofSize: 10)
        ratingLabel.textColor = .lightGray
        
        [imageView, titleLabel, seasonsLabel, starImageView, ratingLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            seasonsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            seasonsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            seasonsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            starImageView.topAnchor.constraint(equalTo: seasonsLabel.bottomAnchor, constant: 2),
            starImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: 12),
            starImageView.heightAnchor.constraint(equalToConstant: 12),
            
            ratingLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 2)
        ])
    }
    
    func configure(with show: TVShow) {
        titleLabel.text = show.title
        seasonsLabel.text = "\(show.seasons) Season\(show.seasons > 1 ? "s" : "")"
        ratingLabel.text = String(format: "%.1f", show.rating)
        
        ImageCacheManager.shared.loadImage(from: show.imageURL) { [weak self] image in
            self?.imageView.image = image
        }
    }
}
