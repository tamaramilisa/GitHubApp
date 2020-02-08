//
//  UserStorage.swift
//  GitHubApp
//
//  Created by Tamara on 08/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import Foundation

class UserStorage {
    
    static var shared = UserStorage()
    
    private var storagedarkMode: Bool = true
    private let darkModeKey = "dark_mode_true"
    var darkMode: Bool {
        get {
            storagedarkMode = UserDefaults.standard.bool(forKey: darkModeKey)
            return storagedarkMode
        }
        set {
            storagedarkMode = newValue
            UserDefaults.standard.setValue(newValue, forKey: darkModeKey)
            UserDefaults.standard.synchronize()
        }
    }
    
}
