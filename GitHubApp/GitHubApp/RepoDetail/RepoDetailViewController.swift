//
//  UserDetailViewController.swift
//  GitHubApp
//
//  Created by Tamara on 04/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import RxGesture

class RepoDetailViewController: UIViewController {
    private let viewModel: RepoDetailViewModelProtocol
    private let disposeBag = DisposeBag()
    private let avatarImageViewSize: CGFloat = 75

    private let repoMainInfoView = UIView()
    
    private let avatarImageView = UIImageView()
    private let repoTitleLabel = UILabel()
    private let usernameLabel = UILabel()
    
    private let separatorView = UIView()
    
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
    
    private let secondSeparatorView = UIView()
    
    private let createdAtLabel = UILabel()
    private let updatedAtLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let languageLabel = UILabel()
    private let urlLabel = UILabel()

    init(viewModel: RepoDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        navigationItem.largeTitleDisplayMode = .never
        title = "Repo details"
        view.backgroundColor = UIColor.appColor(.backgroundColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
        setupRx()
    }
    
    private func setupRx() {
        avatarImageView.rx.tapGesture().when(.recognized)
            .map({ _ in return () })
            .bind { [weak self] _ in
                guard let userName = self?.viewModel.githubRepo.owner?.userName else { return }
                
                Navigator.shared.pushToUserDetail(navigationController: self?.navigationController, username: userName)
            }.disposed(by: disposeBag)
        
        urlLabel.rx.tapGesture().when(.recognized)
            .map({ _ in return () })
            .bind { [weak self] _ in
                guard let urlString = self?.viewModel.githubRepo.url, let url = URL(string: urlString) else { return }
                
                UIApplication.shared.open(url)
            }.disposed(by: disposeBag)
    }
}

// MARK: UI
private extension RepoDetailViewController {
    func render() {
        
        renderUserMainInfoView()
        
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.top.equalTo(repoMainInfoView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        separatorView.backgroundColor = .lightGray
        
        renderNumbersStackView()
        
        view.addSubview(secondSeparatorView)
        secondSeparatorView.snp.makeConstraints { (make) in
            make.top.equalTo(numbersStackView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        secondSeparatorView.backgroundColor = .lightGray
        
        renderOtherUserInfo()
    }
    
    func renderUserMainInfoView() {
        view.addSubview(repoMainInfoView)
        repoMainInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        
        repoMainInfoView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: avatarImageViewSize, height: avatarImageViewSize))
        }
        avatarImageView.setURL(viewModel.githubRepo.owner?.avatarImageUrl)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = avatarImageViewSize / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        repoMainInfoView.addSubview(repoTitleLabel)
        repoTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(20)
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }
        repoTitleLabel.text = viewModel.githubRepo.title
        repoTitleLabel.textColor = UIColor.appColor(.titleTextColor)
        repoTitleLabel.font = UIFont.systemFont(ofSize: 24)
        repoTitleLabel.numberOfLines = 0
        
        repoMainInfoView.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(repoTitleLabel.snp.bottom).offset(8)
            make.left.equalTo(avatarImageView.snp.right).offset(20)
            make.right.equalToSuperview().inset(20)
        }
        usernameLabel.text = viewModel.githubRepo.owner?.userName
        usernameLabel.textColor = .lightGray
        usernameLabel.font = UIFont.systemFont(ofSize: 18)
        usernameLabel.numberOfLines = 0
    }
    
    func renderNumbersStackView() {
        view.addSubview(numbersStackView)
        numbersStackView.snp.makeConstraints { (make) in
            make.top.equalTo(separatorView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
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
        forksCountLabel.text = viewModel.githubRepo.forksCount.description
        forksCountLabel.textColor = .lightGray
        forksCountLabel.font = UIFont.systemFont(ofSize: 20)
        forksCountLabel.textAlignment = .center
        
        forksView.addSubview(forksLabel)
        forksLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(15)
        }
        forksLabel.text = "Forks"
        forksLabel.textColor = .lightGray
        forksLabel.font = UIFont.systemFont(ofSize: 14)
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
        watchersCountLabel.text = viewModel.githubRepo.watchersCount.description
        watchersCountLabel.textColor = .lightGray
        watchersCountLabel.font = UIFont.systemFont(ofSize: 20)
        watchersCountLabel.textAlignment = .center
        
        watchersView.addSubview(watchersLabel)
        watchersLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(15)
        }
        watchersLabel.text = "Watch"
        watchersLabel.textColor = .lightGray
        watchersLabel.font = UIFont.systemFont(ofSize: 14)
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
        issuesCountLabel.text = viewModel.githubRepo.issuesCount.description
        issuesCountLabel.textColor = .lightGray
        issuesCountLabel.font = UIFont.systemFont(ofSize: 20)
        issuesCountLabel.textAlignment = .center
        
        issuesView.addSubview(issuesLabel)
        issuesLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(15)
        }
        issuesLabel.text = "Issues"
        issuesLabel.textColor = .lightGray
        issuesLabel.font = UIFont.systemFont(ofSize: 14)
        issuesLabel.textAlignment = .center
    }
    
    func renderOtherUserInfo() {
        view.addSubview(createdAtLabel)
        createdAtLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(secondSeparatorView.snp.bottom).offset(20)
            make .right.equalToSuperview().inset(24)
        }
        if let date = viewModel.githubRepo.createdAt?.split(separator: "T") {
            let createdDate = date[0].split(separator: "-")
            createdAtLabel.text = "Created at: \(createdDate[2]).\(createdDate[1]).\(createdDate[0])."
        }
        createdAtLabel.textColor = UIColor.appColor(.titleTextColor)
        createdAtLabel.font = UIFont.systemFont(ofSize: 16)
        
        view.addSubview(updatedAtLabel)
        updatedAtLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(createdAtLabel.snp.bottom).offset(20)
            make .right.equalToSuperview().inset(24)
        }
        if let date = viewModel.githubRepo.updatedAt?.split(separator: "T") {
            let updatedDate = date[0].split(separator: "-")
            updatedAtLabel.text = "Updated at: \(updatedDate[2]).\(updatedDate[1]).\(updatedDate[0])."
        }
        updatedAtLabel.textColor = UIColor.appColor(.titleTextColor)
        updatedAtLabel.font = UIFont.systemFont(ofSize: 16)
        
        view.addSubview(languageLabel)
        languageLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(updatedAtLabel.snp.bottom).offset(20)
            make .right.equalToSuperview().inset(24)
        }
        languageLabel.text = "Language: \(viewModel.githubRepo.language ?? "-")"
        languageLabel.textColor = UIColor.appColor(.titleTextColor)
        languageLabel.font = UIFont.systemFont(ofSize: 16)
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(languageLabel.snp.bottom).offset(20)
            make .right.equalToSuperview().inset(24)
        }
        descriptionLabel.text = "Description: \(viewModel.githubRepo.desc ?? "-")"
        descriptionLabel.textColor = UIColor.appColor(.titleTextColor)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        
        view.addSubview(urlLabel)
        urlLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(24)
        }
        urlLabel.text = "Show details"
        urlLabel.textColor = .systemBlue
        urlLabel.font = UIFont.systemFont(ofSize: 16)
    }
}
