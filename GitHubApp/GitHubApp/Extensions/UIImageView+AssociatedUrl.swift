//
//  UIImageView+AssociatedUrl.swift
//  GitHubApp
//
//  Created by Tamara on 06/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setURL(_ url: URL?) {
        if let url = url {
            kf.setImage(with: url,
                        options: [.transition(.fade(0.2))])
        } else {
            image = UIImage(named: "logo_welcome")
        }
    }
    
}
