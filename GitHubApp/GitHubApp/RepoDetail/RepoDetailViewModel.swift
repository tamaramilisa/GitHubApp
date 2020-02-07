//
//  UserDetailViewModel.swift
//  GitHubApp
//
//  Created by Tamara on 04/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import RxSwift

protocol RepoDetailViewModelProtocol {
    var githubRepo: GithubRepository { get }
}

class RepoDetailViewModel: RepoDetailViewModelProtocol {
    var githubRepo: GithubRepository
    
    init(repo: GithubRepository) {
        self.githubRepo = repo
    }
}

