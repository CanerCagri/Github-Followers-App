//
//  Date+Ext.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 22.07.2022.
//

import Foundation

extension Date {
    
    // old way
//    func convertToMonthYearFormat() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM yyyy"
//        return dateFormatter.string(from: self)
//    }
    
    // new way with iOS 15
    func convertToMonthYearFormat() -> String {
        return formatted(.dateTime.month().year())
    }
}
