//
//  UsersViewController.swift
//  GitHubUserManager
//

import UIKit

/// A view controller that displays a list of GitHub users
/// Supports infinite scrolling and caches the user list for offline access
class UsersViewController: UIViewController {
    /// Table view that displays the list of users
   let tableView: UITableView = {
        let table = UITableView()
        table.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    /// Array of GitHub users currently being displayed
    var users: [User] = []
    /// ID of the last user loaded, used for pagination
    private var lastUserId: Int = 0
     /// Flag to prevent multiple simultaneous data fetches
    private var isLoading = false

     /// Service for making network requests to the GitHub API
    private let networkService: NetworkServiceProtocol
     /// Service for caching user data locally
    private let storageService: StorageServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         storageService: StorageServiceProtocol = StorageService()) {
        self.networkService = networkService
        self.storageService = storageService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Called after the view controller has loaded its view hierarchy into memory
    /// Sets up the UI and loads initial user data
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInitialData()
    }
    
    /// Configures the view controller's UI elements
    /// - Sets up the navigation bar title
    /// - Configures the table view and its constraints
    private func setupUI() {
        title = "GitHub Users"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Loads the initial user data
    /// - First attempts to load cached users from storage
    /// - Then fetches fresh data from the network
    private func loadInitialData() {
        if let cachedUsers = storageService.getUsers() {
            users = cachedUsers
            tableView.reloadData()
            lastUserId = users.last?.id ?? 0
        }
        
        fetchUsers()
    }
    
    /// Fetches the next page of GitHub users from the network
    /// - Uses the lastUserId for pagination
    /// - Updates the UI on the main thread when new data arrives
    /// - Saves fetched users to local storage
    private func fetchUsers() {
        guard !isLoading else { return }
        isLoading = true
        
        networkService.fetchUsers(since: lastUserId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let newUsers):
                    self?.users.append(contentsOf: newUsers)
                    self?.lastUserId = newUsers.last?.id ?? self?.lastUserId ?? 0
                    self?.storageService.saveUsers(self?.users ?? [])
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }
    
    /// Displays an error alert to the user
    /// - Parameter error: The network error that occurred
    private func showError(_ error: NetworkError) {
        let alert = UIAlertController(title: "Error",
                                    message: "Failed to fetch users. Please try again.",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    /// Returns the total number of GitHub users in the table view
    /// - Parameters:
    ///   - tableView: The table view requesting this information
    ///   - section: The section index (unused since there's only one section)
    /// - Returns: The total count of users in the data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    /// Configures and returns a cell to display a GitHub user
    /// - Parameters:
    ///   - tableView: The table view requesting the cell
    ///   - indexPath: The index path that specifies the location of the cell
    /// - Returns: A configured UserTableViewCell, or a default UITableViewCell if dequeuing fails
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: users[indexPath.row])
        return cell
    }
    
    /// Called just before a cell is displayed - handles pagination
    /// - Parameters:
    ///   - tableView: The table view containing the cell
    ///   - cell: The cell about to be displayed
    ///   - indexPath: The index path of the cell
    /// - Note: Triggers a fetch of more users when approaching the end of the current data set
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == users.count - 3 {
            fetchUsers()
        }
    }
    
    /// Handles selection of a GitHub user from the list
    /// - Parameters:
    ///   - tableView: The table view where selection occurred
    ///   - indexPath: The index path of the selected row
    /// - Note: Pushes a detail view controller for the selected user onto the navigation stack
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        let detailVC = UserDetailViewController(username: user.login, networkService: networkService)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

