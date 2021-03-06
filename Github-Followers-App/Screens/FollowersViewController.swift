//
//  FollowersViewController.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 18.07.2022.
//

import UIKit


protocol FollowersViewControllerDelegate: AnyObject {
    func didRequestFollowers(username: String)
}


class FollowersViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var userName: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var fetchMoreFollower = true
    var isSearching = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource <Section, Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        fetchFollowers(username: userName, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(view: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func fetchFollowers(username: String, page: Int) {
        showLoading()
        NetworkManager.shared.getFollowers(username: userName, page: page) {[weak self] result in
            self?.dismissLoading()
            switch result {
                
            case .success(let followers):
                if followers.count < 100 {
                    self?.fetchMoreFollower = false
                }
                self?.followers.append(contentsOf: followers)
                
                if self!.followers.isEmpty {
                    let message = "This user not have any follower. 🥲"
                    DispatchQueue.main.async {
                        self?.showEmptyState(message: message, view: self!.view)
                        return
                    }
                }
                self?.updateData(followers: self!.followers)
                
            case .failure(let error):
                self?.presentAlert(title: "Error", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower> (collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(followers: [Follower]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapShot.appendSections([.main])
        snapShot.appendItems(followers)
        
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}

extension FollowersViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard fetchMoreFollower else { return }
            page += 1
            self.fetchFollowers(username: userName, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let followerInfoVC = FollowerDetailViewController()
        followerInfoVC.username = follower.login
        followerInfoVC.delegate = self
        let navigationController = UINavigationController(rootViewController: followerInfoVC)
        present(navigationController, animated: true)
    }
}

extension FollowersViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased())    }
        updateData(followers: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(followers: followers)
    }
}

extension FollowersViewController: FollowersViewControllerDelegate {
    func didRequestFollowers(username: String) {
        self.userName = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        fetchFollowers(username: username, page: page)
    }
}
