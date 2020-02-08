//
//  GithubError.swift
//  GitHubApp
//
//  Created by Tamara on 07/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

class GithubError: SearchCellConfiguration {
    private let error: Error
    
    init(_ error: Error) {
        self.error = error
    }
    
    var title: String {
        return error.localizedDescription
    }
}
