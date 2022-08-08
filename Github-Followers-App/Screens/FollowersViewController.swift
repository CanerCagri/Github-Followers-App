//
//  FollowersViewController.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 18.07.2022.
//

import UIKit


class FollowersViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    
    var page = 1
    var userName: String!
    var fetchMoreFollower = true
    var isSearching = false
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource <Section, Follower>!
    
    init(userName: String) {
        super.init(nibName: nil, bundle: nil)
        self.userName = userName
        title = userName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
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
        isLoadingMoreFollowers = true
        
        Task {
            // Networking good long way with try await - async throws
            do {
                let follower = try await NetworkManager.shared.getFollowers(username: userName, page: page)
                updateUI(followers: follower)
                dismissLoading()
            } catch {
                if let gfError = error as? GFError {
                    presentAlert(title: "Error", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                dismissLoading()
            }
            
            // Networking short way with try? await - async throws
            //            guard let follower = try? await NetworkManager.shared.getFollowers(username: userName, page: page) else {
            //                presentDefaultError()
            //                dismissLoading()
            //                return
            //            }
            //
            //            updateUI(followers: follower)
            //            dismissLoading()
        }
        
        
        // Networking with completion handler
        //        NetworkManager.shared.getFollowers(username: userName, page: page) {[weak self] result in
        //            guard let self = self else { return }
        //            self.dismissLoading()
        //            switch result {
        //
        //            case .success(let followers):
        //                self.updateUI(followers: followers)
        //
        //            case .failure(let error):
        //                self.presentAlert(title: "Error", message: error.rawValue, buttonTitle: "Ok")
        //            }
        //            self.isLoadingMoreFollowers = false
        //        }
    }
    
    func updateUI(followers: [Follower]) {
        if followers.count < 100 {
            self.fetchMoreFollower = false
        }
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            let message = "This user not have any follower. 🥲"
            DispatchQueue.main.async {
                self.showEmptyState(message: message, view: self.view)
                return
            }
        }
        
        self.updateData(followers: self.followers)
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
    
    @objc func addButtonTapped() {
        showLoading()
        
        
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(username: userName)
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else { return }
                    self.dismissLoading()
                    
                    guard let error = error else {
                        self.presentAlert(title: "Success.", message: "You have succesfully favorited this user", buttonTitle: "Ok")
                        return
                    }
                    
                    self.presentAlert(title: "Something Went Wrong", message: error.rawValue, buttonTitle: "Ok")
                }
            } catch {
                if let gfError = error as? GFError {
                    presentAlert(title: "Something went wrong", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                dismissLoading()
            }
        }
        
        //        NetworkManager.shared.getUserInfo(username: userName) { [weak self] result in
        //            guard let self = self else { return }
        //            self.dismissLoading()
        //
        //            switch result {
        //            case .success(let user):
        //                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        //
        //                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
        //                    guard let self = self else { return }
        //
        //                    guard let error = error else {
        //                        self.presentAlert(title: "Success.", message: "You have succesfully favorited this user", buttonTitle: "Ok")
        //                        return
        //                    }
        //
        //                    self.presentAlert(title: "Something Went Wrong", message: error.rawValue, buttonTitle: "Ok")
        //                }
        //
        //            case .failure(let error):
        //                self.presentAlert(title: "Something Went Wrong", message: error.rawValue, buttonTitle: "Ok")
        //            }
        //        }
            }
    }
    
    extension FollowersViewController: UICollectionViewDelegate {
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            if offsetY > contentHeight - height {
                guard fetchMoreFollower, !isLoadingMoreFollowers else { return }
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
    
    extension FollowersViewController: UISearchResultsUpdating {
        func updateSearchResults(for searchController: UISearchController) {
            guard let filter = searchController.searchBar.text, !filter.isEmpty else {
                filteredFollowers.removeAll()
                isSearching = false
                updateData(followers: followers)
                return
            }
            
            isSearching = true
            filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
            updateData(followers: filteredFollowers)
        }
    }
    
    extension FollowersViewController: FollowerDetailViewControllerDelegate {
        func didRequestFollowers(username: String) {
            self.userName = username
            title = username
            page = 1
            followers.removeAll()
            filteredFollowers.removeAll()
            collectionView.setContentOffset(.zero, animated: true)
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            
            fetchFollowers(username: username, page: page)
        }
    }

