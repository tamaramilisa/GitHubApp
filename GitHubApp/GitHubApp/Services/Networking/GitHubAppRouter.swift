//
//  GitHubAppRouter.swift
//  GitHubApp
//
//  Created by Tamara on 01/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import Foundation
import Alamofire

enum GitHubAppRouter: AlamofireRouter {
    static var baseURLString = "https://api.github.com/"
 
    case post(path: String, params: [String : Any]?)
    case postNoAuth(path: String, params: [String : Any]?)
    case delete(path: String, params: [String : Any]?)
    case postJSONEncoding(path: String, params: [String : Any]?)
    case get(path: String, params: [String : Any]?)
    
    var method: HTTPMethod {
        switch self {
        case .get:
            return HTTPMethod.get
        case .post, .postNoAuth, .postJSONEncoding:
            return HTTPMethod.post
        case .delete:
            return HTTPMethod.delete
        }
    }
    
    var params: [String : Any]? {
        switch self {
        case .get(_, let params), .post(_, let params), .postNoAuth(_, let params), .delete(_, let params), .postJSONEncoding(_, let params):
            return params
        }
    }
    
    var url: URL {
        switch self {
        case .get(let path, _), .post(let path, _), .postNoAuth(let path, _), .postJSONEncoding(let path, _), .delete(let path, _):
            guard let url = URL(string: GitHubAppRouter.baseURLString + path) else {
                fatalError("Unable to construct API url")
            }
            return url
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .postNoAuth:
            return URLEncoding.httpBody
        case .delete, .postJSONEncoding:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return nil//["Accept" : "application/vnd.github.mercy-preview+json"]
        }
    }
    
}
