//
//  UserNetworkingService.swift
//  GitHubApp
//
//  Created by Tamara on 06/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import RxSwift
import Alamofire
import RxAlamofire
import SwiftyJSON

protocol UserNetworkingServiceProtocol {
    func getUser(userName: String) -> Observable<GithubUserServerResponse>
}

class UserNetworkingService: UserNetworkingServiceProtocol {
    let networking = AlamofireNetworking()
    
    func getUser(userName: String) -> Observable<GithubUserServerResponse> {
        return networking
            .request(router: GitHubAppRouter.get(path: "users/\(userName)", params: nil))
            .debug()
            .map { (response, data) -> GithubUserServerResponse in
                do {
                    let user = try JSONDecoder().decode(GithubUser.self, from: data)
                    return .success(user)
                } catch let err {
                    return .error(err)
                }
            }
            .catchError { err -> Observable<GithubUserServerResponse> in
                return Observable.just(.error(err))
            }
    }
}
