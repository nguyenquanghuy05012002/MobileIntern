//
//  NetworkServiceTests.swift
//  GitHubUserManager
//

import XCTest
@testable import GitHubUserManager

class MockURLSession: URLSession {
    var mockData: Data?
    var mockError: Error?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask {
            completionHandler(self.mockData, nil, self.mockError)
        }
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}

class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkService = NetworkService()
    }
    
    func testFetchUsersSuccess() {
        let expectation = expectation(description: "Fetch users")
        let mockUsers = [User(id: 1, login: "test", avatarUrl: "url", type: "User", siteAdmin: false, htmlURL: "html")]
        mockSession.mockData = try? JSONEncoder().encode(mockUsers)
        
        networkService.fetchUsers(since: 0) { result in
            switch result {
            case .success(let users):
                XCTAssertEqual(users.count, 20)
                XCTAssertEqual(users[0].login, "mojombo")
            case .failure:
                XCTFail("Should not fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchUsersFailure() {
        let expectation = expectation(description: "Fetch users failure")
        mockSession.mockError = NSError(domain: "", code: -1)
        
        networkService.fetchUsers(since: 0) { result in
            switch result {
            case .success:
                print("Have user")
            case .failure:
                XCTFail("Should fail")
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
