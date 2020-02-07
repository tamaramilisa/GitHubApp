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
import RxGesture

protocol FilterDelegate: AnyObject {
    func filterReposBy(filter: String)
}

enum Filters: String {
    case stars
    case forks
    case updated
    case issues = "help-wanted-issues"
    case bestMatch = ""
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
        starsButton.rx.tapGesture().when(.recognized)
            .map({ _ in return () })
            .bind { [weak self] _ in
                self?.delegate?.filterReposBy(filter: Filters.stars.rawValue)
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        forksButton.rx.tapGesture().when(.recognized)
            .map({ _ in return () })
            .bind { [weak self] _ in
                self?.delegate?.filterReposBy(filter: Filters.forks.rawValue)
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        updatedButton.rx.tapGesture().when(.recognized)
            .map({ _ in return () })
            .bind { [weak self] _ in
                self?.delegate?.filterReposBy(filter: Filters.updated.rawValue)
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        issuesButton.rx.tapGesture().when(.recognized)
        .map({ _ in return () })
        .bind { [weak self] _ in
            self?.delegate?.filterReposBy(filter: Filters.issues.rawValue)
            self?.dismiss(animated: true, completion: nil)
        }
        .disposed(by: disposeBag)
        
        defaultButton.rx.tapGesture().when(.recognized)
            .map({ _ in return () })
            .bind { [weak self] _ in
                self?.delegate?.filterReposBy(filter: Filters.bestMatch.rawValue)
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
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
        starsButton.setTitle("Stars", for: UIControl.State())
        starsButton.setTitleColor(UIColor.appColor(.titleTextColor), for: UIControl.State())
        
        view.addSubview(forksButton)
        forksButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(starsButton.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        forksButton.setTitle("Forks", for: UIControl.State())
        forksButton.setTitleColor(UIColor.appColor(.titleTextColor), for: UIControl.State())
        
        view.addSubview(updatedButton)
        updatedButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(forksButton.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        updatedButton.setTitle("Updated", for: UIControl.State())
        updatedButton.setTitleColor(UIColor.appColor(.titleTextColor), for: UIControl.State())
        
        view.addSubview(issuesButton)
        issuesButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(updatedButton.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        issuesButton.setTitle("Issues", for: UIControl.State())
        issuesButton.setTitleColor(UIColor.appColor(.titleTextColor), for: UIControl.State())
        
        view.addSubview(defaultButton)
        defaultButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(issuesButton.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        defaultButton.setTitle("Default", for: UIControl.State())
        defaultButton.setTitleColor(UIColor.appColor(.titleTextColor), for: UIControl.State())
    }
}
