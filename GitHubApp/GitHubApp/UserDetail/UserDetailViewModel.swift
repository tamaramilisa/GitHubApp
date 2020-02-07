//
//  UserDetailViewModel.swift
//  GitHubApp
//
//  Created by Tamara on 04/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import RxSwift

protocol UserDetailViewModelProtocol {
    var networkingService: UserNetworkingServiceProtocol { get }
    var username: String { get }
    var githubUserSubject: PublishSubject<GithubUserServerResponse> { get }
}

class UserDetailViewModel: UserDetailViewModelProtocol {
    var networkingService: UserNetworkingServiceProtocol
    var username: String
    var githubUserSubject = PublishSubject<GithubUserServerResponse>()
    
    private var bag = DisposeBag()
    
    init(username: String, networkingService: UserNetworkingServiceProtocol) {
        self.username = username
        self.networkingService = networkingService
        
        networkingService
            .getUser(userName: username)
            .bind(to: githubUserSubject)
            .disposed(by: bag)
        
    }
}

