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
        
        Navigator.shared.start()
        
        return true
    }
}

