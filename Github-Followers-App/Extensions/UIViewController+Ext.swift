//
//  UIViewController+Ext.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 18.07.2022.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController {
    
    func presentAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalTransitionStyle = .crossDissolve
            alertVC.modalPresentationStyle = .overFullScreen
            self.present(alertVC, animated: true)
        }
    }
    
    func presentSafari(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
    func showLoading() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func dismissLoading() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    func showEmptyState(message: String, view: UIView) {
        let emptyState = GFEmptyStateView(message: message)
        emptyState.frame = view.bounds
        view.addSubview(emptyState)
    }
}
