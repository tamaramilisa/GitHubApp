//
//  FilterViewController.swift
//  GitHubApp
//
//  Created by Tamara on 06/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

protocol FilterDelegate: AnyObject {
    func filterReposBy(filter: Filter)
}

enum Filter {
    case stars
    case forks
    case updated
    case issues
    case bestMatch
    
    var title: String {
        switch self {
        case .stars:
            return "Stars"
        case .forks:
            return "Forks"
        case .updated:
            return "Updated"
        case .issues:
            return "Help wanted issues"
        case .bestMatch:
            return "Best match"
        }
    }
    
    var filter: String {
        switch self {
        case .stars:
            return "stars"
        case .forks:
            return "forks"
        case .updated:
            return "updated"
        case .issues:
            return "help-wanted-issues"
        case .bestMatch:
            return ""
        }
    }
}

class FilterViewController: UIViewController {
    
    private var starsButton = UIButton()
    private var forksButton = UIButton()
    private var updatedButton = UIButton()
    private let issuesButton = UIButton()
    private var defaultButton = UIButton()
    
    weak var delegate: FilterDelegate?
    
    private let disposeBag = DisposeBag()
    
    init(delegate: FilterDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        title = "Filter by:"
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
        starsButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.filterReposBy(filter: Filter.stars)
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        forksButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.filterReposBy(filter: Filter.forks)
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        updatedButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.filterReposBy(filter: Filter.updated)
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        issuesButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.filterReposBy(filter: Filter.issues)
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        defaultButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.filterReposBy(filter: Filter.bestMatch)
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
}

// MARK: UI
private extension FilterViewController {
    func render() {
        view.addSubview(starsButton)
        starsButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        starsButton.setTitle(Filter.stars.title, for: UIControl.State())
        starsButton.setTitleColor(UIColor.appColor(.titleTextColor), for: UIControl.State())
        
        view.addSubview(forksButton)
        forksButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(starsButton.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        forksButton.setTitle(Filter.forks.title, for: UIControl.State())
        forksButton.setTitleColor(UIColor.appColor(.titleTextColor), for: UIControl.State())
        
        view.addSubview(updatedButton)
        updatedButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(forksButton.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        updatedButton.setTitle(Filter.updated.title, for: UIControl.State())
        updatedButton.setTitleColor(UIColor.appColor(.titleTextColor), for: UIControl.State())
        
        view.addSubview(issuesButton)
        issuesButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(updatedButton.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        issuesButton.setTitle(Filter.issues.title, for: UIControl.State())
        issuesButton.setTitleColor(UIColor.appColor(.titleTextColor), for: UIControl.State())
        
        view.addSubview(defaultButton)
        defaultButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(issuesButton.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        defaultButton.setTitle(Filter.bestMatch.title, for: UIControl.State())
        defaultButton.setTitleColor(UIColor.appColor(.titleTextColor), for: UIControl.State())
    }
}
