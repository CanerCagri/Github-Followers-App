//
//  GFFollowerImageView.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 19.07.2022.
//

import UIKit

class GFFollowerImageView: UIImageView {

    let cache = NetworkManager.shared.cache
    let placeHolderImage = Images.placeHolder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeHolderImage
    }
}
