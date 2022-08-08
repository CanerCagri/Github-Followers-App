//
//  GFRepoItemViewController.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 22.07.2022.
//

import UIKit

protocol GFRepoItemViewControllerDelegate: AnyObject {
    func didTapGithubProfile(user: User)
}

class GFRepoItemViewController: GFItemInfoViewController {
    
    weak var delegate: GFRepoItemViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoOne.set(itemInfoType: .repos, count: user.publicRepos)
        itemInfoTwo.set(itemInfoType: .gists, count: user.publicGists)
        actionButton.set(color: .systemPurple, title: "Github Profile", systemImageName: "person")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGithubProfile(user: user)
    }
}
