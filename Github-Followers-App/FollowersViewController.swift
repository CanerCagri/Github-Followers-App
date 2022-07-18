//
//  FollowersViewController.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 18.07.2022.
//

import UIKit

class FollowersViewController: UIViewController {
    
    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        // For big title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
