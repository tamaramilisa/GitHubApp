//
//  AlamofireNetworking.swift
//  GitHubApp
//
//  Created by Tamara on 01/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

protocol AlamofireRouter {
    var method: HTTPMethod { get }
    var params: [String: Any]? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var headers: [String: String]? { get }
}

typealias ResponseObservable = Observable<(HTTPURLResponse, Data)>
typealias DataResponseObservable = Observable<DataResponse<Data>>
typealias DefaultObservableResponse<T: Codable> = Observable<Result<DefaultResponse<T>>>
typealias StatusCodeOKObservable = Observable<Result<Void>>

class AlamofireNetworking {
    
    func request(router: AlamofireRouter) -> ResponseObservable {
        return RxAlamofire
            .requestData(router.method, router.url, parameters: router.params, encoding: router.encoding, headers: router.headers)
            .observeOn(MainScheduler.instance)
    }

}
