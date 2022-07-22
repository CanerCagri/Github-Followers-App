//
//  GFError.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 19.07.2022.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please try again."
    case invalidResponse = "Invalid response from server. Please try again."
    case invalidData = "Invalid data from server. Please try again."
    
}
