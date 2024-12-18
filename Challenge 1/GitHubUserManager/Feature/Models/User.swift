//
//  User.swift
//  GitHubUserManager
//

/// A model representing a GitHub user.
struct User: Codable {
    let id: Int
    let login: String
    let avatarUrl: String
    let type: String
    let siteAdmin: Bool
    let htmlURL: String
    
    /// Coding keys for mapping between JSON and Swift property names.
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case type
        case siteAdmin = "site_admin"
        case htmlURL = "html_url"
    }
}
