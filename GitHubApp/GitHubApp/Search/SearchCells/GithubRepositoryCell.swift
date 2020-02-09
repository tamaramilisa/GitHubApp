//
//  GithubRepositoryCell.swift
//  GitHubApp
//
//  Created by Tamara on 01/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

class GithubRepositoryCell: UITableViewCell {
    private var repository: GithubRepository?
    var disposeBag = DisposeBag()
    
    private var containerView = UIView()
    
    private let avatarImageView = UIImageView()
    private let avatarImageViewSize: CGFloat = 42
    
    private let rowsContainerView = UIView()
    
    private let repositoryNameLabel = UILabel()
    private let usernameLabel = UILabel()
    
    private let numbersStackView = UIStackView()
    private let forksView = UIView()
    private let forksLabel = UILabel()
    private let forksCountLabel = UILabel()
    private let issuesView = UIView()
    private let issuesLabel = UILabel()
    private let issuesCountLabel = UILabel()
    private let watchersView = UIView()
    private let watchersLabel = UILabel()
    private let watchersCountLabel = UILabel()
    
    
    var userTapped = PublishSubject<GithubOwner?>()
    var repositoryTapped = PublishSubject<GithubRepository?>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with repository: GithubRepository) {
        self.repository = repository
        
        repositoryNameLabel.text = repository.name
        if let userName = repository.owner?.userName {
            usernameLabel.text = userName
        }
        avatarImageView.setURL(repository.owner?.avatarImageUrl)
        forksCountLabel.text = repository.forksCount.description
        watchersCountLabel.text = repository.watchersCount.description
        issuesCountLabel.text = repository.issuesCount.description
        
        setupTapsObservables()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

// MARK: Observables
private extension GithubRepositoryCell {
    private func setupTapsObservables() {
        avatarImageView.rx.tapGesture().when(.recognized)
            .map({ _ in return self.repository?.owner })
            .bind(to: userTapped)
            .disposed(by: disposeBag)
        
        rowsContainerView.rx.tapGesture().when(.recognized)
            .map({ _ in return self.repository })
            .bind(to: repositoryTapped)
            .disposed(by: disposeBag)
    }
}

// MARK: UI
private extension GithubRepositoryCell {
    func render() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
        containerView.backgroundColor = UIColor.appColor(.titleTextColor)?.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        
        renderAvatar()
        renderRightView()
    }
    
    func renderAvatar() {
        containerView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: avatarImageViewSize, height: avatarImageViewSize))
        }
        avatarImageView.layer.cornerRadius = avatarImageViewSize / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
        avatarImageView.contentMode = .scaleAspectFill
    }
    
    func renderRightView() {
        containerView.addSubview(rowsContainerView)
        rowsContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(0)
            make.top.equalTo(avatarImageView.snp.top)
            make.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(20)
        }
        
        renderRepositoryName()
        renderUsername()
        renderStackViews()
    }
    
    func renderRepositoryName() {
        rowsContainerView.addSubview(repositoryNameLabel)
        repositoryNameLabel.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        repositoryNameLabel.font = UIFont.systemFont(ofSize: 18)
        repositoryNameLabel.numberOfLines = 0
        repositoryNameLabel.textColor = UIColor.appColor(.titleTextColor)
    }
    
    func renderUsername() {
        rowsContainerView.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(repositoryNameLabel.snp.bottom).offset(4)
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        usernameLabel.font = UIFont.systemFont(ofSize: 16)
        usernameLabel.numberOfLines = 0
        usernameLabel.textColor = .systemGray
    }
    
    func renderStackViews() {
        rowsContainerView.addSubview(numbersStackView)
        numbersStackView.snp.makeConstraints { (make) in
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(35)
        }
        
        numbersStackView.axis = .horizontal
        numbersStackView.distribution = .equalSpacing
        
        numbersStackView.addArrangedSubview(forksView)
        forksView.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
        }
        
        forksView.addSubview(forksCountLabel)
        forksCountLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(15)
        }
        forksCountLabel.textColor = .systemGray
        forksCountLabel.font = UIFont.systemFont(ofSize: 16)
        forksCountLabel.textAlignment = .center
        
        forksView.addSubview(forksLabel)
        forksLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(15)
        }
        forksLabel.text = "Forks"
        forksLabel.textColor = .systemGray
        forksLabel.font = UIFont.systemFont(ofSize: 12)
        forksLabel.textAlignment = .center
        
        numbersStackView.addArrangedSubview(watchersView)
        watchersView.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
        }
        
        watchersView.addSubview(watchersCountLabel)
        watchersCountLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(15)
        }
        watchersCountLabel.textColor = .systemGray
        watchersCountLabel.font = UIFont.systemFont(ofSize: 16)
        watchersCountLabel.textAlignment = .center
        
        watchersView.addSubview(watchersLabel)
        watchersLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(15)
        }
        watchersLabel.text = "Watch"
        watchersLabel.textColor = .systemGray
        watchersLabel.font = UIFont.systemFont(ofSize: 12)
        watchersLabel.textAlignment = .center
        
        numbersStackView.addArrangedSubview(issuesView)
        issuesView.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
        }
        
        issuesView.addSubview(issuesCountLabel)
        issuesCountLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(15)
        }
        issuesCountLabel.textColor = .systemGray
        issuesCountLabel.font = UIFont.systemFont(ofSize: 16)
        issuesCountLabel.textAlignment = .center
        
        issuesView.addSubview(issuesLabel)
        issuesLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(15)
        }
        issuesLabel.text = "Issues"
        issuesLabel.textColor = .systemGray
        issuesLabel.font = UIFont.systemFont(ofSize: 12)
        issuesLabel.textAlignment = .center
    }
}
