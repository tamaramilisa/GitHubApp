//
//  EmptyResultsCell.swift
//  GitHubApp
//
//  Created by Tamara on 01/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import UIKit

enum EmptyResultsCellState: String {
    case noResults
    case errorState
    case noQuery
}

class EmptyResultsCell: UITableViewCell {
    private let iconImageViewDimensions: CGFloat = 100
    private let cellHeight: CGFloat = UIScreen.main.bounds.height / 2
    
    private let containerView = UIView()
    private var descriptionLabel = UILabel()
    private var iconImageView = UIImageView()
    
    private var state: EmptyResultsCellState = .noQuery
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(state: EmptyResultsCellState) {
        switch state {
        case .noResults:
            iconImageView.image = UIImage(named: "logo_empty_result")
            descriptionLabel.text = "There are no such repositories here. Check your query and try again."
        case .errorState:
            iconImageView.image = UIImage(named: "logo_error")
            descriptionLabel.text = "There has been an error. Try refreshing."
        case .noQuery:
            iconImageView.image = UIImage(named: "logo_welcome")
            descriptionLabel.text = "Enter a query and search GitHub repositories."
        }
    }
}

private extension EmptyResultsCell {
    func render() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
            make.height.equalTo(cellHeight)
        }
        
        containerView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(24)
            make.height.width.equalTo(iconImageViewDimensions)
        }
        iconImageView.contentMode = .scaleAspectFill
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().inset(24)
        }
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor.appColor(.titleTextColor)
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.numberOfLines = 0
        
    }
}
