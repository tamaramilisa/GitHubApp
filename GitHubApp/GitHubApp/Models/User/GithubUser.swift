//
//  GithubUser.swift
//  GitHubApp
//
//  Created by Tamara on 02/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import Foundation

class GithubUser: Codable {
    var id: Int = 0
    var userName: String?
    var avatarUrl: String?
    var url: String?
    var type: String?
    var bio: String?
    var publicRepos: Int = 0
    var publicGists: Int = 0
    var followers: Int = 0
    var following: Int = 0
    var location: String = "private"
    
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
        case bio
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case following
        case followers
    }
    
    
}
