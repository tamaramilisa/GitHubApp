//
//  SearchNetworkingService.swift
//  GitHubApp
//
//  Created by Tamara on 01/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import RxSwift
import Alamofire
import RxAlamofire
import SwiftyJSON

protocol SearchNetworkingServiceProtocol {
    func search(query: String, sortBy: String) -> Observable<GithubRepositoryServerResult>
}

class SearchNetworkingService: SearchNetworkingServiceProtocol {
    let networking = AlamofireNetworking()
    
    func search(query: String, sortBy: String = "") -> Observable<GithubRepositoryServerResult> {
        let params: [String : Any] = [
            "q" : query,
            "sort" : sortBy,
            "page" : 1,
            "per_page" : 40
        ]
        
        return networking
            .request(router: GitHubAppRouter.get(path: "search/repositories", params: params))
            .debug()
            .map { (response, data) -> GithubRepositoryServerResult in
                let dataJson = JSON(data)
                do {
                    let itemsData = try dataJson["items"].rawData()
                    let repos = try JSONDecoder().decode([GithubRepository].self, from: itemsData)
                    return repos.isEmpty ? .empty(.noResults) : .success(repos)
                } catch let err {
                    return .error(GithubError(err))
                }
            }
            
        }
}

