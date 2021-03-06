//
//  Color.swift
//  GitHubApp
//
//  Created by Tamara on 04/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import UIKit

extension UIColor {
    
//    struct AppColors {
//        static var backgroundColor: UIColor? {
//            return UIColor(named: "backgroundColor")
//        }
//
//        static var titleTextColor: UIColor? {
//            return UIColor(named: "titleTextColor")
//        }
//    }
    
    enum AppColors: String {
        case backgroundColor
        case titleTextColor
    }

    static func appColor(_ name: AppColors) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
}
