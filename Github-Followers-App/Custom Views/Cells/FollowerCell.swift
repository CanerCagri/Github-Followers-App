//
//  FollowerCell.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 19.07.2022.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    
    static let reuseID = "FollowerCell"
    let followerImageView = GFFollowerImageView(frame: .zero)
    let userNameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    let padding: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: Follower) {
        userNameLabel.text = follower.login
        NetworkManager.shared.downloadImage(urlString: follower.avatarUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.followerImageView.image = image
            }
        }
    }
    
    private func configure() {
        addSubviews(followerImageView, userNameLabel)
        
        NSLayoutConstraint.activate([
            followerImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            followerImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            followerImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            followerImageView.heightAnchor.constraint(equalTo: followerImageView.widthAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: followerImageView.bottomAnchor, constant: 12),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
