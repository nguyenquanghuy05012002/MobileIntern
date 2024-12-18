//
//  StorageService.swift
//  GitHubUserManager
//

import Foundation

/// Protocol defining methods for storing and retrieving GitHub users
protocol StorageServiceProtocol {
    /// Saves an array of users to persistent storage
    /// - Parameter users: Array of User objects to save
    func saveUsers(_ users: [User])
    
    /// Retrieves saved users from persistent storage
    /// - Returns: Array of User objects if any exist, nil otherwise
    func getUsers() -> [User]?
    
    /// Removes all saved users from persistent storage
    func clearUsers()
}

/// Service class that handles persistent storage of GitHub users using UserDefaults
class StorageService: StorageServiceProtocol {
    /// UserDefaults instance used for storage
    private let userDefaults = UserDefaults.standard
    /// Key used to store users in UserDefaults
    private let usersKey = "cached_users"
    
    /// Saves an array of users to UserDefaults by encoding to JSON data
    /// - Parameter users: Array of User objects to save
    func saveUsers(_ users: [User]) {
        if let encoded = try? JSONEncoder().encode(users) {
            userDefaults.set(encoded, forKey: usersKey)
        }
    }
    
    /// Retrieves and decodes saved users from UserDefaults
    /// - Returns: Array of User objects if successfully retrieved and decoded, nil otherwise
    func getUsers() -> [User]? {
        guard let data = userDefaults.data(forKey: usersKey) else { return nil }
        return try? JSONDecoder().decode([User].self, from: data)
    }
    
    /// Removes saved users data from UserDefaults
    func clearUsers() {
        userDefaults.removeObject(forKey: usersKey)
    }
}