//
//  GithubOwner.swift
//  GitHubApp
//
//  Created by Tamara on 06/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import Foundation

class GithubOwner: Codable {
    var id: Int = 0
    var userName: String?
    var avatarUrl: String?
    var url: String?
    var type: String?
    
    var avatarImageUrl: URL? {
        if let image = avatarUrl {
            return URL(string: image)
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "login"
        case avatarUrl = "avatar_url"
        case url = "html_url"
        case type
    }
}
