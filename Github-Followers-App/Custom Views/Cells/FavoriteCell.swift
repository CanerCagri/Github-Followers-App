//
//  FavoriteCell.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 1.08.2022.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    static let reuseID = "FavoriteCell"
    let favoriteImageView = GFFollowerImageView(frame: .zero)
    let userNameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    let padding: CGFloat = 12

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(favorite: Follower) {
        userNameLabel.text = favorite.login
        NetworkManager.shared.downloadImage(urlString: favorite.avatarUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.favoriteImageView.image = image
            }
        }
    }
    
    private func configure() {
        addSubviews(favoriteImageView, userNameLabel)
        
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate([
            favoriteImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            favoriteImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 60),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 60),
            
            userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: favoriteImageView.trailingAnchor, constant: 24),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
