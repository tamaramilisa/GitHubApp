//
//  GithubRepository.swift
//  GitHubApp
//
//  Created by Tamara on 01/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import Foundation

class GithubRepository: Codable {
    var id: Int = 0
    var name: String?
    var fullName: String?
    var isPrivate: Bool = false
    var owner: GithubOwner?
    var url: String?
    var desc: String?
    var createdAt: String?
    var updatedAt: String?
    var watchersCount: Int = 0
    var forksCount: Int = 0
    var issuesCount: Int = 0
    var language: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case isPrivate = "private"
        case owner
        case url = "html_url"
        case desc = "description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case issuesCount = "open_issues_count"
        case language 
    }
}

extension GithubRepository: SearchCellConfiguration {
    var title: String {
        return name ?? ""
    }
    
}
