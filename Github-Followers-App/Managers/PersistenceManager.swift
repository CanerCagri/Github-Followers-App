//
//  PersistenceManager.swift
//  Github-Followers-App
//
//  Created by Caner Çağrı on 1.08.2022.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }

    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping (GFError?) -> Void) {
        getFavorites { result in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completion(.alreadyInFavorites)
                        return
                    }
                    
                    favorites.append(favorite)
                    
                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }
                
                completion(saveFavorites(followers: favorites))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func getFavorites(completion: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let allFavorites = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: allFavorites)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorites))
        }
    }
    
    static func saveFavorites(followers: [Follower]) -> GFError? {
        
        do {
            let encoder = JSONEncoder()
            let favorites = try encoder.encode(followers)
            defaults.set(favorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorites
        }
    }
}
