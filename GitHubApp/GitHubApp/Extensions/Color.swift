//
//  Color.swift
//  GitHubApp
//
//  Created by Tamara on 04/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import UIKit

extension UIColor {
    
    enum AppColors: String {
        case backgroundColor
        case titleTextColor
        case cellBackgroundColor
    }
    
    static func appColor(_ name: AppColors) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
    
}
