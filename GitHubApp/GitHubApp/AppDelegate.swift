//
//  AppDelegate.swift
//  GitHubApp
//
//  Created by Tamara on 31/01/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        checkForDarkMode()
        
        Navigator.shared.start()
        
        return true
    }
    
    private func checkForDarkMode() {
        if #available(iOS 12.0, *) {
            switch UIScreen.main.traitCollection.userInterfaceStyle {
            case .dark:
                UserStorage.shared.darkMode = true
            default:
                UserStorage.shared.darkMode = false
            }
        } else {
             UserStorage.shared.darkMode = false
        }
    }


}

