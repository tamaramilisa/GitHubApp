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

class UserDetailViewController: UIViewController {
    private let viewModel: UserDetailViewModelProtocol
    private let disposeBag = DisposeBag()
    private let avatarImageViewSize: CGFloat = 90

    private let userMainInfoView = UIView()
    
    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    
    private let separatorView = UIView()
    
    private let followersStackView = UIStackView()
    private let followersView = UIView()
    private let followersLabel = UILabel()
    private let numberOfFollowersLabel = UILabel()
    private let followingView = UIView()
    private let followingLabel = UILabel()
    private let numberOfFollowingLabel = UILabel()
    
    private let secondSeparatorView = UIView()
    
    private let typeLabel = UILabel()
    private let locationLabel = UILabel()
    private let numberOfReposLabel = UILabel()
    private let numberOfGistsLabel = UILabel()
    private let urlLabel = UILabel()
    
    private var user: GithubUser?

    init(viewModel: UserDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        navigationItem.largeTitleDisplayMode = .never
        title = "User details"
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
        viewModel.githubUserSubject
            .subscribe(onNext: { [weak self] (response) in
                switch response {
                case .success(let user):
                    self?.user = user
                    self?.setupUIWithUser(user: user)
                case .error(let err):
                    print("Err: \(err)")
                }
            }).disposed(by: disposeBag)
        
        urlLabel.rx.tapGesture().when(.recognized)
            .map({ _ in return () })
            .bind { [weak self] _ in
                guard let user = self?.user, let urlString = user.url, let url = URL(string: urlString) else { return }
                
                UIApplication.shared.open(url)
            }.disposed(by: disposeBag)
    }
    
    private func setupUIWithUser(user: GithubUser) {
        avatarImageView.setURL(user.avatarImageUrl)
        usernameLabel.text = user.userName
        numberOfFollowersLabel.text = user.followers.description
        numberOfFollowingLabel.text = user.following.description
        typeLabel.text = "Type: \(user.type ?? "-")"
        locationLabel.text = "Location: \(user.location)"
        numberOfReposLabel.text = "No of repos: \(user.publicRepos.description)"
        numberOfGistsLabel.text = "No of gists: \(user.publicGists.description)"
    }
}

// MARK: UI
private extension UserDetailViewController {
    func render() {
        
        renderUserMainInfoView()
        
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.top.equalTo(userMainInfoView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        separatorView.backgroundColor = .lightGray
        
        renderFollowersStackView()
        
        view.addSubview(secondSeparatorView)
        secondSeparatorView.snp.makeConstraints { (make) in
            make.top.equalTo(followersStackView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        secondSeparatorView.backgroundColor = .lightGray
        
        renderOtherUserInfo()
    }
    
    func renderUserMainInfoView() {
        view.addSubview(userMainInfoView)
        userMainInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        
        userMainInfoView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: avatarImageViewSize, height: avatarImageViewSize))
        }
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = avatarImageViewSize / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        userMainInfoView.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }
        usernameLabel.textColor = UIColor.appColor(.titleTextColor)
        usernameLabel.font = UIFont.systemFont(ofSize: 24)
        usernameLabel.textAlignment = .center
    }
    
    func renderFollowersStackView() {
        userMainInfoView.addSubview(followersStackView)
        followersStackView.snp.makeConstraints { (make) in
            make.top.equalTo(separatorView).offset(20)
            make.left.equalToSuperview().offset(80)
            make.right.equalToSuperview().inset(80)
            make.height.equalTo(40)
        }
        
        followersStackView.axis = .horizontal
        followersStackView.distribution = .equalSpacing
        
        followersStackView.addArrangedSubview(followersView)
        followersView.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
        }
        
        followersView.addSubview(numberOfFollowersLabel)
        numberOfFollowersLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(20)
        }
        numberOfFollowersLabel.textColor = .systemGray
        numberOfFollowersLabel.font = UIFont.systemFont(ofSize: 22)
        numberOfFollowersLabel.textAlignment = .center
        
        followersView.addSubview(followersLabel)
        followersLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        followersLabel.text = "Followers"
        followersLabel.textColor = .systemGray
        followersLabel.font = UIFont.systemFont(ofSize: 16)
        followersLabel.textAlignment = .center
        
        followersStackView.addArrangedSubview(followingView)
        followingView.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
        }
        
        followingView.addSubview(numberOfFollowingLabel)
        numberOfFollowingLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(20)
        }
        numberOfFollowingLabel.textColor = .systemGray
        numberOfFollowingLabel.font = UIFont.systemFont(ofSize: 22)
        numberOfFollowingLabel.textAlignment = .center
        
        followingView.addSubview(followingLabel)
        followingLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        followingLabel.text = "Following"
        followingLabel.textColor = .systemGray
        followingLabel.font = UIFont.systemFont(ofSize: 16)
        followingLabel.textAlignment = .center
    }
    
    func renderOtherUserInfo() {
        view.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(secondSeparatorView.snp.bottom).offset(20)
            make .right.equalToSuperview().inset(24)
        }
        typeLabel.textColor = UIColor.appColor(.titleTextColor)
        typeLabel.font = UIFont.systemFont(ofSize: 18)
        
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(typeLabel.snp.bottom).offset(20)
            make .right.equalToSuperview().inset(24)
        }
        locationLabel.textColor = UIColor.appColor(.titleTextColor)
        locationLabel.font = UIFont.systemFont(ofSize: 18)
        
        view.addSubview(numberOfReposLabel)
        numberOfReposLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(locationLabel.snp.bottom).offset(20)
            make .right.equalToSuperview().inset(24)
        }
        numberOfReposLabel.textColor = UIColor.appColor(.titleTextColor)
        numberOfReposLabel.font = UIFont.systemFont(ofSize: 18)
        
        view.addSubview(numberOfGistsLabel)
        numberOfGistsLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(numberOfReposLabel.snp.bottom).offset(20)
            make .right.equalToSuperview().inset(24)
        }
        numberOfGistsLabel.textColor = UIColor.appColor(.titleTextColor)
        numberOfGistsLabel.font = UIFont.systemFont(ofSize: 18)
        
        view.addSubview(urlLabel)
        urlLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(numberOfGistsLabel.snp.bottom).offset(20)
            make .right.equalToSuperview().inset(24)
        }
        urlLabel.text = "Show user details"
        urlLabel.textColor = .systemBlue
        urlLabel.font = UIFont.systemFont(ofSize: 18)
    }
}
