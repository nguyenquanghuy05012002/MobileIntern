# GitHub User Manager

## Overview
GitHub User Manager is an iOS application that allows users to browse and view GitHub user profiles. The app features:

- Infinite scrolling list of GitHub users
- Detailed user profiles including:
  - Avatar image
  - Bio information
  - Repository count
  - Follower/Following statistics
  - Location, blog, and company details
- Offline support with local caching
- Clean and modern UI with card-based design

## Requirements
- iOS 15.2+
- Xcode 14.0+
- Swift 5.0+

## Building and Running

1. Clone the repository
    - git clone [repository-url]
    - cd GitHubUserManager

2. Open the project in Xcode
    - open GitHubUserManager.xcodeproj
3. Select your target device/simulator and click Run (⌘ + R)

## Architecture

The app follows a clean architecture pattern with:

- Feature-based file organization
- Protocol-oriented networking
- Local storage for offline support
- UIKit with programmatic UI
- Dependency injection for better testability

Key components:
- `UsersViewController`: Main list view with infinite scrolling
- `UserDetailViewController`: Detailed user profile view
- `NetworkService`: Handles GitHub API communication
- `StorageService`: Manages local data persistence

## Challenges and Solutions

1. **Infinite Scrolling**
   - Implemented pagination using GitHub's API
   - Used table view prefetching for smooth scrolling
   - Reference: [UsersViewController.swift, lines 149-153]

2. **Image Loading**
   - Asynchronous image loading with URLSession
   - Proper memory management using weak self
   - Reference: [UserDetailViewController.swift, lines 207-215]

3. **Offline Support**
   - Implemented local storage for user data
   - Seamless fallback to cached data when offline
   - Reference: [UsersViewController.swift, lines 72-76]

## Testing

The project includes:
- Unit tests for view controllers and services
- UI tests for critical user flows
- Mock services for network testing

## Future Improvements

1. Add search functionality
2. Implement user authentication
3. Add repository list view
4. Improve image caching
5. Add pull-to-refresh functionality

## Demo

https://drive.google.com/file/d/1VNQAtr5lDFG3EBuSwSW5NDYzULMtT0BA/view?usp=sharing
