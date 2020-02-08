//
//  Navigator.swift
//  GitHubApp
//
//  Created by Tamara on 01/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import UIKit

class Navigator {
    private var window: UIWindow?
    
    static let shared = Navigator()
    
    private init() {}
    
    func start() {
        self.window = UIWindow()
        window?.makeKeyAndVisible()
        startHome()
    }
    
    private func startHome() {
        let searchNetworkingService = SearchNetworkingService()
        let searchVM = SearchViewModel(networkingService: searchNetworkingService)
        let searchVC = SearchViewController(viewModel: searchVM)
        let homeNavigation = RootNavigationController(rootViewController: searchVC)
        window?.rootViewController = homeNavigation
    }
    
    func pushToUserDetail(navigationController: UINavigationController?, username: String) {
        let userNetworkingService = UserNetworkingService()
        let userDetailVM = UserDetailViewModel(username: username, networkingService: userNetworkingService)
        let userDetailVC = UserDetailViewController(viewModel: userDetailVM)
        navigationController?.pushViewController(userDetailVC, animated: true)
    }
    
    func pushToRepoDetail(navigationController: UINavigationController?, repo: GithubRepository) {
        let repoDetailVM = RepoDetailViewModel(repo: repo)
        let repoDetailVC = RepoDetailViewController(viewModel: repoDetailVM)
        navigationController?.pushViewController(repoDetailVC, animated: true)
    }
    
    func presentFilterScreen(navigationController: UINavigationController?, delegate: FilterDelegate) {
        let filterVC = FilterViewController(delegate: delegate)
        let navController = UINavigationController(rootViewController: filterVC)
        navigationController?.present(navController, animated: true, completion: nil)
    }
}
