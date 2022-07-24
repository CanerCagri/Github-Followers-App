//
//  FollowerDetailViewController.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 21.07.2022.
//

import UIKit


protocol FollowerDetailVCDelegate: AnyObject {
    func didTapGithubProfile(user: User)
    func didTapGetFollowers(user: User)
}

class FollowerDetailViewController: UIViewController {
    
    let headerView = UIView()
    let containerViewOne = UIView()
    let containerViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    var containers: [UIView] = []
    weak var delegate: FollowersViewControllerDelegate!
    var username: String!
    let padding: CGFloat = 20
    let itemHeight: CGFloat = 140
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        fetchUser()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func fetchUser() {
        NetworkManager.shared.getUserInfo(username: username) { [weak self] result in
            switch result {
                
            case .success(let user):
                DispatchQueue.main.async {
                    self!.configureUI(user: user)
                }
                
            case .failure(let error):
                self?.presentAlert(title: "Something went wrong!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureUI(user: User) {
        let repoItemVC = GFRepoItemViewController(user: user)
        repoItemVC.delegate = self
        let followerItemVC = GFFollowerItemViewController(user: user)
        followerItemVC.delegate = self
        
        self.add(childVC: GFInfoHeaderViewController(user: user), containerView: self.headerView)
        self.add(childVC: repoItemVC, containerView: self.containerViewOne)
        self.add(childVC: followerItemVC, containerView: self.containerViewTwo)
        self.dateLabel.text = "Github Since \(user.createdAt.convertToDisplayFormat())"
    }
    
    func layoutUI() {
        containers = [headerView, containerViewOne, containerViewTwo, dateLabel]
        
        for containerViews in containers {
            view.addSubview(containerViews)
            containerViews.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            containerViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            containerViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            containerViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            containerViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            containerViewTwo.topAnchor.constraint(equalTo: containerViewOne.bottomAnchor, constant: padding),
            containerViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            containerViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            containerViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dateLabel.topAnchor.constraint(equalTo: containerViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func add(childVC: UIViewController, containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

extension FollowerDetailViewController: FollowerDetailVCDelegate {
    func didTapGithubProfile(user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentAlert(title: "Invalid URL", message: "This user url is invalid. Please try again ", buttonTitle: "Ok")
            return
        }
        presentSafari(url: url)
    }
    
    func didTapGetFollowers(user: User) {
        guard user.followers != 0 else {
            presentAlert(title: "No followers", message: "This user not have followers🥲", buttonTitle: "Ok")
            return
        }
        delegate.didRequestFollowers(username: user.login)
        dismissVC()
    }
    
    
}
