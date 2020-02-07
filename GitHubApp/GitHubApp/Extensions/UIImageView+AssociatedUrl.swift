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
    
    func setURL(_ URL: URL?, indicatorType: IndicatorType = .none) {
        guard let url = URL else {
            image = UIImage(named: "logo_welcome")
            return
        }
        kf.indicatorType = indicatorType
        kf.setImage(with: url,
                    placeholder: UIImage(named: "logo_welcome"),
                    options: [.transition(.fade(0.2))],
                    progressBlock: nil) { [weak self] (result) in
                        switch result {
                        case .success(let imageResult):
                            self?.imageDownloaded(image: imageResult.image, error: nil)
                        case .failure(let error):
                            self?.imageDownloaded(image: nil, error: error)
                        }
        }
    }
    
    private func imageDownloaded(image: Image?, error: Error?) {
        if error == nil {
            self.image = image
        } else {
            self.image = UIImage(named: "logo_welcome")
        }
    }
    
}
