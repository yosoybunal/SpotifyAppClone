//
//  AlbumTrackCollectionView.swift
//  SpotifyClone
//
//  Created by Berkay Unal on 20.11.2023.
//

import UIKit

class AlbumTrackCollectionView: UICollectionViewCell {
    
    static let identifier = "AlbumTrackCollectionView"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x: 10, y: 0, width: contentView.width-15, height: contentView.height/2)
        descriptionLabel.frame = CGRect(x: 10, y: contentView.height/2.8, width: contentView.width-15, height: contentView.height/2.5)
    }
    
    func configure(viewModel: RecommendedTrackCellViewModel) {
        
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.artistName
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        descriptionLabel.text = nil
    }
    

}
