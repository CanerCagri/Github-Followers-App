//
//  FollowerDetailViewController.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 21.07.2022.
//

import UIKit


protocol FollowerDetailViewControllerDelegate: AnyObject {
    func didRequestFollowers(username: String)
}

class FollowerDetailViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UIView()
    let containerViewOne = UIView()
    let containerViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    var containers: [UIView] = []
    weak var delegate: FollowerDetailViewControllerDelegate!
    var username: String!
    let padding: CGFloat = 20
    let itemHeight: CGFloat = 140
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        layoutUI()
        fetchUser()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureScrollView() {
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        
        scrollView.pinToEdges(view: view)
        contentView.pinToEdges(view: scrollView)
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 600).isActive = true
        
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
        self.dateLabel.text = "Github Since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    func layoutUI() {
        containers = [headerView, containerViewOne, containerViewTwo, dateLabel]
        
        for containerViews in containers {
            contentView.addSubview(containerViews)
            containerViews.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            containerViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            containerViewOne.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerViewOne.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            containerViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            containerViewTwo.topAnchor.constraint(equalTo: containerViewOne.bottomAnchor, constant: padding),
            containerViewTwo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerViewTwo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            containerViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            dateLabel.topAnchor.constraint(equalTo: containerViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
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

extension FollowerDetailViewController: GFRepoItemViewControllerDelegate {
    func didTapGithubProfile(user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentAlert(title: "Invalid URL", message: "This user url is invalid. Please try again ", buttonTitle: "Ok")
            return
        }
        presentSafari(url: url)
    }
}

extension FollowerDetailViewController: GFFollowerItemViewControllerDelegate {
    func didTapGetFollowers(user: User) {
        guard user.followers != 0 else {
            presentAlert(title: "No followers", message: "This user not have followers🥲", buttonTitle: "Ok")
            return
        }
        delegate.didRequestFollowers(username: user.login)
        dismissVC()
        
    }
}

