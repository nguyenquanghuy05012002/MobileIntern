//
//  UserDetail.swift
//  GitHubUserManager
//

/// Represents detailed information about a GitHub user
struct UserDetail: Codable {
    let id: Int
    let login: String
    let avatarUrl: String
    let name: String?
    let bio: String?
    let location: String?
    let email: String?
    let publicRepos: Int
    let followers: Int
    let following: Int
    let createdAt: String
    let company: String
    let blog: String?

    /// Mapping between JSON keys and Swift property names
    enum CodingKeys: String, CodingKey {
        case id, login, name, bio, location, email, company, blog
        case avatarUrl = "avatar_url"
        case publicRepos = "public_repos"
        case followers, following
        case createdAt = "created_at"
    }
}
