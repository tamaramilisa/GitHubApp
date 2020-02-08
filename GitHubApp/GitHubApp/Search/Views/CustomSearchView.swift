//
//  CustomSearchView.swift
//  GitHubApp
//
//  Created by Tamara on 04/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import UIKit
import SnapKit

class CustomSearchView: UIView {
    
    let searchBar = UISearchBar()
    let filterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        render()
    }
    
}

private extension CustomSearchView {
    func render() {
        
        self.addSubview(filterImageView)
        filterImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(20)
        }
        filterImageView.image = UIImage(named: "filter")
        filterImageView.contentMode = .scaleAspectFit
        filterImageView.tintColor = UIColor.AppColors.titleTextColor
        
        self.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(filterImageView.snp.left).offset(-8)
        }
        searchBar.backgroundImage = UIImage()
    }
}
