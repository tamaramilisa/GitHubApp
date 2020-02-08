//
//  Color.swift
//  GitHubApp
//
//  Created by Tamara on 04/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import UIKit

extension UIColor {
    
    struct AppColors {
        static var backgroundColor: UIColor? {
            return UserStorage.shared.darkMode == false ? UIColor(red: 1, green: 1, blue: 1, alpha: 1) : UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        static var titleTextColor: UIColor? {
            return UserStorage.shared.darkMode == false ? UIColor(red: 0, green: 0, blue: 0, alpha: 1) : UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
}
