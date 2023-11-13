//
//  NewReleasesCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Berkay Unal on 15.11.2023.
//

import UIKit
import SDWebImage

class NewReleasesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewReleasesCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .light)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemFill
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height-10
        let albumLabelSize = albumNameLabel.sizeThatFits(CGSize(width: contentView.width-imageSize-10, height: contentView.height-10))
        
        numberOfTracksLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        albumNameLabel.frame = CGRect(
            x: Int(albumCoverImageView.right)+10,
            y: 5,
            width: Int(contentView.width)-Int(albumCoverImageView.width)-15,
            height: min(80, Int(contentView.height)-10))
        
        artistNameLabel.frame = CGRect(
            x: Int(albumCoverImageView.right)+10,
            y: Int(albumCoverImageView.bottom)-65,
            width: Int(contentView.width) - Int(albumCoverImageView.right)-5,
            height: min(80, Int(albumLabelSize.height)))
        
        numberOfTracksLabel.frame = CGRect(
            x: Int(albumCoverImageView.right)+10,
            y: Int(albumCoverImageView.bottom)-50,
            width: Int(contentView.width)-Int(albumCoverImageView.width),
            height: 44)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumNameLabel.text = nil
        numberOfTracksLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleasesCellViewModel) {
        
        albumNameLabel.text = viewModel.name
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        artistNameLabel.text = viewModel.artistName
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        
    }
}
