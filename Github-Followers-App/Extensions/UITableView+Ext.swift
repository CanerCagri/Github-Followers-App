//
//  UITableView+Ext.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 6.08.2022.
//

import UIKit

extension UITableView {
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
