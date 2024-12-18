//
//  NetworkService.swift
//  GitHubUserManager
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
}

/// Service responsible for making network requests to the GitHub API
protocol NetworkServiceProtocol {
    /// Fetches a list of GitHub users
    /// - Parameters:
    ///   - since: User ID to start fetching from (for pagination)
    ///   - completion: Callback with the result containing either users or an error
    func fetchUsers(since: Int, completion: @escaping (Result<[User], NetworkError>) -> Void)
    
    /// Fetches detailed information about a specific GitHub user
    /// - Parameters:
    ///   - username: The username of the GitHub user
    ///   - completion: Callback with the result containing either user details or an error
    func fetchUserDetail(username: String, completion: @escaping (Result<UserDetail, NetworkError>) -> Void)
}

/// Implementation of the NetworkServiceProtocol for GitHub API requests
class NetworkService: NetworkServiceProtocol {
    /// Base URL for the GitHub API
    private let baseURL = "https://api.github.com"
    
    /// Fetches a list of GitHub users with pagination support
    /// - Parameters:
    ///   - since: User ID to start fetching from (for pagination)
    ///   - completion: Callback with the result containing either users or an error
    /// - Note: This method fetches 20 users per page
    func fetchUsers(since: Int, completion: @escaping (Result<[User], NetworkError>) -> Void) {
        let urlString = "\(baseURL)/users?since=\(since)&per_page=20"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    /// Fetches detailed information for a specific GitHub user
    /// - Parameters:
    ///   - username: The username of the GitHub user to fetch details for
    ///   - completion: Callback with the result containing either user details or an error
    /// - Note: This method makes a request to the GitHub API's user endpoint
    func fetchUserDetail(username: String, completion: @escaping (Result<UserDetail, NetworkError>) -> Void) {
        let urlString = "\(baseURL)/users/\(username)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let userDetail = try JSONDecoder().decode(UserDetail.self, from: data)
                completion(.success(userDetail))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}