//
//  GFFollowerItemViewController.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 22.07.2022.
//

import Foundation
import UIKit

protocol GFFollowerItemViewControllerDelegate: AnyObject { 
    func didTapGetFollowers(user: User)
}

class GFFollowerItemViewController: GFItemInfoViewController {
    
    weak var delegate: GFFollowerItemViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    func configureItems() {
        itemInfoOne.set(itemInfoType: .followers, count: user.followers)
        itemInfoTwo.set(itemInfoType: .following, count: user.following)
        actionButton.set(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(user: user)
    }
}
