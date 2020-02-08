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
    
    var querySubject: PublishSubject<String> { get }
    var filterSubject: PublishSubject<Filter> { get }
    var pageSubject: PublishSubject<Int> { get }
    var perPage: Int { get }
    
    var reposRelay: BehaviorRelay<[GithubRepository]> { get }
    
    func shouldIncrementPageNumber(page: Int, index: Int) -> Bool
    func setupScanForRepos()
}

class SearchViewModel: SearchViewModelProtocol {
    
    var networkingService: SearchNetworkingServiceProtocol
    var searchResult: Observable<GithubRepositoryServerResult>!
    
    var querySubject = PublishSubject<String>()
    var filterSubject = PublishSubject<Filter>()
    var pageSubject = PublishSubject<Int>()
    var perPage = 30
    
    var reposRelay = BehaviorRelay<[GithubRepository]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    init(networkingService: SearchNetworkingServiceProtocol) {
        self.networkingService = networkingService
        
        searchResult = Observable
            .combineLatest(querySubject, filterSubject.startWith(Filter.bestMatch), pageSubject.startWith(1)) { ($0, $1, $2)}
            .flatMapLatest({ [weak self] (query, filter, page) -> Observable<GithubRepositoryServerResult> in
                guard let `self` = self else { return Observable.empty() }
                return self.networkingService.search(query: query, sortBy: filter.filter, page: page, perPage: self.perPage)
            })
    }
    
    func setupScanForRepos() {
        reposRelay.scan([]) { (allRepos, newRepos) -> [GithubRepository] in
            return allRepos + newRepos
        }
        .subscribe(onNext: { [weak self] (repos) in
            self?.reposRelay.accept(repos)
        }).disposed(by: disposeBag)
    }

    func shouldIncrementPageNumber(page: Int, index: Int) -> Bool {
        let currentOffset = page * perPage
        return index == currentOffset - perPage / 2

    }
}
