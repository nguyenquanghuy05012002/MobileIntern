//
//  UserDetailViewController.swift
//  GitHubUserManager
//

import UIKit
/// A view controller that displays detailed information about a GitHub user
/// This includes their avatar, name, bio, and various statistics like followers and following counts
class UserDetailViewController: UIViewController {
    /// Scroll view that contains all the user information
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    /// Main container view for all content within the scroll view
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     /// Displays the user's avatar image
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let locationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let blogView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let companyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let username: String
     /// Service for making network requests to the GitHub API
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Initialization
    
    /// Creates a new UserDetailViewController
    /// - Parameters:
    ///   - username: The GitHub username of the user to display
    ///   - networkService: The service used to fetch user details
    init(username: String, networkService: NetworkServiceProtocol) {
        self.username = username
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Required initializer that is not supported
    /// - Parameter coder: NSCoder instance for interface builder initialization
    /// - Returns: Never returns, always fails with a fatal error
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Lifecycle method called after the view controller is loaded into memory
    /// Sets up the initial UI configuration and fetches user data
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        fetchUserDetails()
    }
    
    /// Configures the main user interface of the view controller
    /// Sets up the view hierarchy, adds subviews and configures layout constraints
    private func setupUI() {
        title = username
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bioLabel)
        contentView.addSubview(statsStackView)
        contentView.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            bioLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bioLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            statsStackView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 20),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            statsStackView.bottomAnchor.constraint(equalTo: infoStackView.topAnchor, constant: -30),
            
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    private func setupNavigationBar() {
        title = "User Details"
        
        // Hide back button title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Or if you want to customize the back button completely
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    /// Fetches detailed user information from the network service
    /// - Note: Updates UI on the main thread when data is received
    private func fetchUserDetails() {
        networkService.fetchUserDetail(username: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userDetail):
                    self?.updateUI(with: userDetail)
                case .failure:
                    self?.showError()
                }
            }
        }
    }
    
    /// Updates the UI elements with user details
    /// - Parameter user: The UserDetail model containing user information
    private func updateUI(with user: UserDetail) {
        nameLabel.text = user.name ?? user.login
        bioLabel.text = user.bio ?? "No bio available"
        
        if let url = URL(string: user.avatarUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.avatarImageView.image = image
                    }
                }
            }.resume()
        }
        
        setupStatsView(repos: user.publicRepos, followers: user.followers, following: user.following)
        
        // Clear existing info views
        infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Add location if available
        if let location = user.location {
            let locationRow = createInfoRow(icon: "location.fill", text: location)
            infoStackView.addArrangedSubview(locationRow)
        }

        // Add blog if available
        if let blog = user.blog, !blog.isEmpty {
            let blogRow = createInfoRow(icon: "link", text: blog)
            infoStackView.addArrangedSubview(blogRow)
        }

        // Add company if available
        if !user.company.isEmpty {
            let companyRow = createInfoRow(icon: "building.2.fill", text: user.company)
            infoStackView.addArrangedSubview(companyRow)
        }
    }
    
    /// Configures the stats view with user statistics
    /// - Parameters:
    ///   - repos: Number of public repositories
    ///   - followers: Number of followers
    ///   - following: Number of users being followed
    private func setupStatsView(repos: Int, followers: Int, following: Int) {
        let stats = [
            ("Repos", repos),
            ("Followers", followers),
            ("Following", following)
        ]
        
        stats.enumerated().forEach { index, stat in
            if index > 0 {
                let separator = UIView()
                separator.backgroundColor = .systemGray4
                separator.translatesAutoresizingMaskIntoConstraints = false
                statsStackView.addArrangedSubview(separator)
                
                NSLayoutConstraint.activate([
                    separator.widthAnchor.constraint(equalToConstant: 1),
                    separator.heightAnchor.constraint(equalToConstant: 40)
                ])
            }
            
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            stack.spacing = 2
            
            let countLabel = UILabel()
            countLabel.text = "\(stat.1)"
            countLabel.font = .systemFont(ofSize: 20, weight: .bold)
            
            let titleLabel = UILabel()
            titleLabel.text = stat.0
            titleLabel.font = .systemFont(ofSize: 14)
            titleLabel.textColor = .gray
            
            stack.addArrangedSubview(countLabel)
            stack.addArrangedSubview(titleLabel)
            
            statsStackView.setCustomSpacing(1, after: stack) // Reduced spacing between items
            statsStackView.addArrangedSubview(stack)
        }
    }
    
    /// Displays an error alert to the user
    private func showError() {
        let alert = UIAlertController(title: "Error",
                                    message: "Failed to fetch user details. Please try again.",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func createInfoRow(icon: String, text: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemGray6  // Light gray background
        container.layer.cornerRadius = 8         // Rounded corners
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: icon)
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16)     // Slightly larger font
        label.textColor = .label                 // Default text color
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(imageView)
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            // Add padding to container
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
        
        return container
    }
}
