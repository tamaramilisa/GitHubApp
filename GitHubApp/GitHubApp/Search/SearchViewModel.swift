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
    var nextPageSubject: PublishSubject<Void> { get }
    var perPage: Int { get }
    
    func resetPagination()
}

class SearchViewModel: SearchViewModelProtocol {
    
    var networkingService: SearchNetworkingServiceProtocol
    var searchResult: Observable<GithubRepositoryServerResult>!
    
    var querySubject = PublishSubject<String>()
    var filterSubject = PublishSubject<Filter>()
    var nextPageSubject = PublishSubject<Void>()
    var perPage: Int = 30
    var isLoadingPage = false
    private var nextPage = 0
    private var reposArray: [GithubRepository] = []
    private var totalNoOfItems: Int = 0
    
    private let disposeBag = DisposeBag()
    
    init(networkingService: SearchNetworkingServiceProtocol) {
        self.networkingService = networkingService
        
        let pageChangedSubject = nextPageSubject.startWith(())
            .filter { [weak self] _ -> Bool in
                guard let `self` = self, self.nextPage <= (self.totalNoOfItems / self.perPage) else { return false }
                return !self.isLoadingPage}
            .do(onNext: { [weak self] _ in
                self?.nextPage += 1
            })
        
        searchResult = Observable
            .combineLatest(querySubject.distinctUntilChanged(), filterSubject.startWith(Filter.bestMatch), pageChangedSubject.startWith()) { ($0, $1, $2)}
            .flatMapLatest({ [weak self] (query, filter, _) -> Observable<GithubRepositoryServerResult> in
                guard let `self` = self else { return Observable.empty() }
                self.isLoadingPage = true
                return self.networkingService.search(query: query, sortBy: filter.filter, page: self.nextPage, perPage: self.perPage)
            })
            .map { [weak self] serverResult in
                guard let `self` = self else { return serverResult }
                self.isLoadingPage = false
                return self.mapServerResult(serverResult: serverResult)
        }
    }
    
    func resetPagination() {
        nextPage = 1
    }
    
    private func mapServerResult(serverResult: GithubRepositoryServerResult) -> GithubRepositoryServerResult {
        
        switch serverResult {
        case .success(let repos, let totalNoOfItems):
            self.totalNoOfItems = totalNoOfItems
            if self.nextPage == 1 {
                self.reposArray = repos
            } else {
                self.reposArray.append(contentsOf: repos)
            }
            return .success((self.reposArray, self.totalNoOfItems))
        default:
            return serverResult
        }
    }
}
