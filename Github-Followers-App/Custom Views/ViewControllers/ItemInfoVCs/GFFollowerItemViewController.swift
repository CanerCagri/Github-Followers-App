//
//  GFFollowerItemViewController.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 22.07.2022.
//

import Foundation

import UIKit

class GFFollowerItemViewController: GFItemInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    func configureItems() {
        itemInfoOne.set(itemInfoType: .followers, count: user.followers)
        itemInfoTwo.set(itemInfoType: .following, count: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(user: user)
    }
}
