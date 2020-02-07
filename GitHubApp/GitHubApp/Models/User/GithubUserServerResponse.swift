//
//  GithubUserServerResponse.swift
//  GitHubApp
//
//  Created by Tamara on 06/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import Foundation

enum GithubUserServerResponse {
    case success(GithubUser)
    case error(Error)
}
