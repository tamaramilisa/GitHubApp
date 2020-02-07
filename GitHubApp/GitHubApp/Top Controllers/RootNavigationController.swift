//
//  RootNavigationController.swift
//  GitHubApp
//
//  Created by Tamara on 31/01/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import Foundation
import UIKit

class RootNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .default
        
        navigationBar.prefersLargeTitles = true
    }
    
}
