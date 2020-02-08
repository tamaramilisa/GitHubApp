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
    private let filterByView = UIView()
    private let filterByLabel = UILabel()
    
    private let tableView = UITableView()
    private let repositoryCellReuseIndentifier = "GithubRepositoryCell"
    private let emptyResultsCellReuseIdentifier = "EmptyResultsCell"
    
    private let activityIndicator = UIActivityIndicatorView()
    private let activityIndicatorBackgrounView = UIView()
    
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
                self?.activityIndicatorBackgrounView.isHidden = true
                self?.activityIndicator.stopAnimating()
                switch response {
                case .success(let repositories):
                    self?.viewModel.reposRelay.accept(repositories)
                case .error(let error):
                    self?.dataSource = [error]
                    self?.tableView.reloadData()
                case .empty(let state):
                    self?.dataSource = [state]
                    self?.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
        
        viewModel.filterSubject
            .startWith(Filter.bestMatch)
            .subscribe(onNext: { [weak self] (filter) in
                self?.filterByLabel.text = "Sort: \(filter.title)"
            }).disposed(by: disposeBag)
        
        viewModel.reposRelay
            .skip(1)
            .subscribe(onNext: { [weak self] (repos) in
                self?.dataSource = repos
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        customSearchBar.searchBar.rx.text
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (text) in
                guard let `self` = self else { return }
                guard let `text` = text, !text.isEmpty else {
                    self.dataSource = [EmptyResultState.noQuery]
                    self.tableView.reloadData()
                    return
                }
            
                self.activityIndicatorBackgrounView.isHidden = false
                self.activityIndicator.startAnimating()
                self.viewModel.querySubject.onNext(text)
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
            }.disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .map { $0.indexPath.row }
            .withLatestFrom(viewModel.pageSubject) { ($1, $0) }
            .filter { [weak self] (page, index) -> Bool in
                print(page)
                return self?.viewModel.shouldIncrementPageNumber(page: page, index: index) ?? false
            }
            .map { $0.0 + 1 }
            .bind(to: viewModel.pageSubject)
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
        
        view.addSubview(filterByView)
        filterByView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(customSearchBar.snp.bottom)
            make.height.equalTo(30)
        }
        filterByView.backgroundColor = UIColor.appColor(.cellBackgroundColor)?.withAlphaComponent(0.05)
        
        filterByView.addSubview(filterByLabel)
        filterByLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
        filterByLabel.text = "Sort:"
        filterByLabel.font = UIFont.systemFont(ofSize: 16)
        filterByLabel.textColor = UIColor.appColor(.titleTextColor)?.withAlphaComponent(0.5)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(filterByView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        tableView.keyboardDismissMode = .onDrag
        
        view.addSubview(activityIndicatorBackgrounView)
        activityIndicatorBackgrounView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(70)
        }
        activityIndicatorBackgrounView.backgroundColor = UIColor.appColor(.cellBackgroundColor)?.withAlphaComponent(0.4)
        activityIndicatorBackgrounView.layer.cornerRadius = 35
        activityIndicatorBackgrounView.clipsToBounds = true
        activityIndicatorBackgrounView.isHidden = true
        
        activityIndicatorBackgrounView.addSubview(activityIndicator)
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
                   
        filterByView.isHidden = true
        cell.configure(state: state)

        return cell
    }
    
    func configureGithubRepositoryCell(indexPath: IndexPath) -> UITableViewCell {
        let dequeued = tableView.dequeueReusableCell(withIdentifier: repositoryCellReuseIndentifier)
        guard let cell = dequeued as? GithubRepositoryCell else {
            return UITableViewCell()
        }
        
        filterByView.isHidden = false
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
    func filterReposBy(filter: Filter) {
        guard let query = customSearchBar.searchBar.text else { return }
        activityIndicatorBackgrounView.isHidden = false
        activityIndicator.startAnimating()
        viewModel.filterSubject.onNext(filter)
    }
}
