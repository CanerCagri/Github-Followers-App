//
//  SearchViewController.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 17.07.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    let imageView = UIImageView()
    let nameTextField = GFTextField()
    let getFollowersButton = GFButton(title: "Get Followers", backgroundColor: .systemGreen)
    var imageViewTopConstraint: NSLayoutConstraint!
    
    var isUsernameEntered: Bool {
        return !nameTextField.text!.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Systembackground is making background while in light mode "white", dark mode "black"
        view.backgroundColor = .systemBackground
        createImageView()
        createNameTextField()
        createGetFollowersButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func pushFollowersVC() {
        guard isUsernameEntered else {
            presentAlert(title: "Empty Username", message: "Please enter Github username", buttonTitle: "Ok")
            return
        }
        
        nameTextField.resignFirstResponder()
        
        let followersVC = FollowersViewController(userName: nameTextField.text!)
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    func createImageView() {
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Images.ghLogo
        
        //Checking iphone model and when we open keyboard if it is blocking textfield we changing top constraint and giving it space for textfield
        let topConstarintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8PlusZoomed ? 20 : 80
        
        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstarintConstant)
        imageViewTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func createNameTextField() {
        view.addSubview(nameTextField)
        nameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 48),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func createGetFollowersButton() {
        view.addSubview(getFollowersButton)
        getFollowersButton.addTarget(self, action: #selector(pushFollowersVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            getFollowersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            getFollowersButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            getFollowersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            getFollowersButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersVC()
        return true
    }
}
