//
//  UsersViewControllerTests.swift
//  GitHubUserManager
//

import XCTest
@testable import GitHubUserManager

class MockNetworkService: NetworkServiceProtocol {
    var mockUsers: [User] = []
    var mockError: NetworkError?
    
    func fetchUsers(since: Int, completion: @escaping (Result<[User], NetworkError>) -> Void) {
        if let error = mockError {
            completion(.failure(error))
        } else {
            completion(.success(mockUsers))
        }
    }
    
    func fetchUserDetail(username: String, completion: @escaping (Result<UserDetail, NetworkError>) -> Void) {
        // Not needed for these tests
    }
}

class MockStorageService: StorageServiceProtocol {
    var mockUsers: [User]?
    
    func saveUsers(_ users: [User]) {
        mockUsers = users
    }
    
    func getUsers() -> [User]? {
        return mockUsers
    }
    
    func clearUsers() {
        mockUsers = nil
    }
}

class UsersViewControllerTests: XCTestCase {
    var sut: UsersViewController!
    var mockNetworkService: MockNetworkService!
    var mockStorageService: MockStorageService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockStorageService = MockStorageService()
        sut = UsersViewController(networkService: mockNetworkService, storageService: mockStorageService)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        mockStorageService = nil
        super.tearDown()
    }
    
    func testInitialDataLoad() {
        // Given
        let mockUsers = [User(id: 1, login: "test", avatarUrl: "url", type: "User", siteAdmin: false, htmlURL: "html")]
        mockStorageService.mockUsers = mockUsers
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(sut.users.count, 1)
        XCTAssertEqual(sut.users.first?.login, "test")
    }
    
    func testFetchUsersSuccess() {
        // Given
        let mockUsers = [User(id: 1, login: "test", avatarUrl: "url", type: "User", siteAdmin: false, htmlURL: "html")]
        mockNetworkService.mockUsers = mockUsers
        
        // When
        sut.viewDidLoad()
        
        // Then
        // Use expectation to wait for async operation
        let expectation = XCTestExpectation(description: "Fetch users")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut.users.count, 0)
            XCTAssertEqual(self.mockStorageService.mockUsers?.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchUsersFailure() {
        // Given
        mockNetworkService.mockError = .noData
        
        // When
        sut.viewDidLoad()
        
        // Then
        let expectation = XCTestExpectation(description: "Fetch users failure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.sut.users.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
