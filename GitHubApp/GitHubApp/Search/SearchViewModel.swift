//
//  SearchViewModel.swift
//  GitHubApp
//
//  Created by Tamara on 01/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SearchViewModelProtocol {
    var networkingService: SearchNetworkingServiceProtocol { get }
    var searchResult: Observable<GithubRepositoryServerResult>! { get }
    var searchQuerySubject: PublishSubject<(String, String)> { get }
}

class SearchViewModel: SearchViewModelProtocol {
    var networkingService: SearchNetworkingServiceProtocol
    var searchResult: Observable<GithubRepositoryServerResult>!
    
    var searchQuerySubject = PublishSubject<(String, String)>()
    
    private let bag = DisposeBag()
    
    init(networkingService: SearchNetworkingServiceProtocol) {
        self.networkingService = networkingService
        
        searchResult = searchQuerySubject
            .flatMapLatest({ [weak self] (query, filter) -> Observable<GithubRepositoryServerResult> in
                guard let `self` = self else { return Observable.empty() }
                return self.networkingService.search(query: query, sortBy: filter)
            })
    }
    
}
