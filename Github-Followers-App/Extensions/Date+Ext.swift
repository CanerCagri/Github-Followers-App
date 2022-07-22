//
//  Date+Ext.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 22.07.2022.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        return dateFormatter.string(from: self)
    }
}
