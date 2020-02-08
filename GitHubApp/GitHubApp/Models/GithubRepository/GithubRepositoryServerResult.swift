//
//  GithubRepositoryServerResult.swift
//  GitHubApp
//
//  Created by Tamara on 01/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

enum GithubRepositoryServerResult {
    // Array of results and total number of items
    case success(([GithubRepository],Int))
    case error(GithubError)
    case empty(EmptyResultState)
}
