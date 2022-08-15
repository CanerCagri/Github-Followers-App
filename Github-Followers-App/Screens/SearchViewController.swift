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
    let getFollowersButton = GFButton(title: "Get Followers", color: .systemBlue, systemImageName: "person.3")
    
    var isUsernameEntered: Bool {
        return !nameTextField.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Systembackground is making background while in light mode "white", dark mode "black"
        view.backgroundColor = .systemBackground
        view.addSubviews(imageView, nameTextField, getFollowersButton)
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
        
        let textField = nameTextField.text
        
        if textField!.contains("https://github.com/") == true {
            
            let result = textField?.components(separatedBy: "github.com/")
            let followersVC = FollowersViewController(userName: result![1])
            navigationController?.pushViewController(followersVC, animated: true)
        } else {
            
            let followersVC = FollowersViewController(userName: nameTextField.text!)
            navigationController?.pushViewController(followersVC, animated: true)
        }
    }
    
    func createImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Images.ghLogo
        
        //Checking iphone model and when we open keyboard if it is blocking textfield we changing top constraint and giving it space for textfield
        let topConstarintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8PlusZoomed ? 20 : 80
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstarintConstant),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func createNameTextField() {
        nameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 48),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func createGetFollowersButton() {
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
