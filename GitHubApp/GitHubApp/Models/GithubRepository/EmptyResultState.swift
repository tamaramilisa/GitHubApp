//
//  EmptyResultState.swift
//  GitHubApp
//
//  Created by Tamara on 07/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

enum EmptyResultState: SearchCellConfiguration {
    case noQuery
    case noResults
    
    var titleText: String {
        switch self {
        case .noQuery:
            return "noQuery"
        case .noResults:
            return "noResults"
        }
    }
    
    var title: String {
        return titleText
    }
}
