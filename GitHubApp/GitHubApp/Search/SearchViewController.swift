//
//  SearchViewController.swift
//  GitHubApp
//
//  Created by Tamara on 01/02/2020.
//  Copyright © 2020 Tamara. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class SearchViewController: UIViewController {
    private let viewModel: SearchViewModelProtocol
    private let disposeBag = DisposeBag()
    
    private let customSearchBar = CustomSearchView()
    private let tableView = UITableView()
    private let repositoryCellReuseIndentifier = "GithubRepositoryCell"
    private let emptyResultsCellReuseIdentifier = "EmptyResultsCell"
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private var dataSource: [SearchCellConfiguration] = [EmptyResultState.noQuery]
    
    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Search"
        view.backgroundColor = UIColor.appColor(.backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
        setupRx()
        setupTableView()
    }
    
    private func setupRx() {
        
        viewModel.searchResult
            .startWith(.empty(.noQuery))
            .subscribe(onNext: { [weak self] response in
                self?.activityIndicator.stopAnimating()
                switch response {
                case .success(let repositories):
                    self?.dataSource = repositories
                    self?.tableView.reloadData()
                case .error(let error):
                    self?.dataSource = [error]
                    self?.tableView.reloadData()
                case .empty(let state):
                    self?.dataSource = [state]
                    self?.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
        
        customSearchBar.searchBar.rx.text
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (text) in
                guard let `self` = self else { return }
                guard let `text` = text, !text.isEmpty else { return }
            
                self.activityIndicator.startAnimating()
                self.viewModel.searchQuerySubject.onNext((text, ""))
            }).disposed(by: disposeBag)
        
        customSearchBar.searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                
                self.customSearchBar.searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        customSearchBar.filterImageView.rx.tapGesture().when(.recognized)
        .map({ _ in return () })
        .bind { [weak self] _ in
            guard let `self` = self else { return }
            
            Navigator.shared.presentFilterScreen(navigationController: self.navigationController, delegate: self)
        }
        .disposed(by: disposeBag)
    }
}

// MARK: UI
private extension SearchViewController {
    func render() {
        view.addSubview(customSearchBar)
        customSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(customSearchBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        tableView.keyboardDismissMode = .onDrag
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        activityIndicator.style = .whiteLarge
        activityIndicator.isUserInteractionEnabled = false
    }
    
    
}

// MARK: Table View
extension SearchViewController: UITableViewDataSource {
    private func setupTableView() {
        tableView.register(GithubRepositoryCell.self, forCellReuseIdentifier: repositoryCellReuseIndentifier)
        tableView.register(EmptyResultsCell.self, forCellReuseIdentifier: emptyResultsCellReuseIdentifier)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource[indexPath.row] {
        case is EmptyResultState:
            let condition = dataSource[indexPath.row].title == EmptyResultsCellState.noResults.rawValue
            return condition ? configureEmptyResultsCell(state: .noResults) : configureEmptyResultsCell(state: .noQuery)
        case is GithubError:
            return configureEmptyResultsCell(state: .errorState)
        default:
            return configureGithubRepositoryCell(indexPath: indexPath)
        }
    }
}

// MARK: Configure cells
private extension SearchViewController {
    func configureEmptyResultsCell(state: EmptyResultsCellState) -> UITableViewCell {
        let dequeued = tableView.dequeueReusableCell(withIdentifier: emptyResultsCellReuseIdentifier)
        guard let cell = dequeued as? EmptyResultsCell else {
            return UITableViewCell()
        }
                   
        cell.configure(state: state)

        return cell
    }
    
    func configureGithubRepositoryCell(indexPath: IndexPath) -> UITableViewCell {
        let dequeued = tableView.dequeueReusableCell(withIdentifier: repositoryCellReuseIndentifier)
        guard let cell = dequeued as? GithubRepositoryCell else {
            return UITableViewCell()
        }
        
        if let repository = dataSource[indexPath.row] as? GithubRepository {
            cell.setup(with: repository)
            observeRepositoryCellTapps(cell)
            return cell
        }

        return UITableViewCell()
    }
}

// MARK: Cells Observables
private extension SearchViewController {
    func observeRepositoryCellTapps(_ cell: GithubRepositoryCell) {
        cell.userTapped
            .subscribe(onNext: { [weak self] user in
                guard let userName = user?.userName else { return }
                Navigator.shared.pushToUserDetail(navigationController: self?.navigationController, username: userName)
            }).disposed(by: cell.disposeBag)
        
        cell.repositoryTapped
            .subscribe(onNext: { repository in
                guard let repo = repository else { return }
                Navigator.shared.pushToRepoDetail(navigationController: self.navigationController, repo: repo)
            }).disposed(by: cell.disposeBag)
    }
}

extension SearchViewController: FilterDelegate {
    func filterReposBy(filter: String) {
        guard let query = customSearchBar.searchBar.text else { return }
        activityIndicator.startAnimating()
        viewModel.searchQuerySubject.onNext((query, filter))
    }
}
