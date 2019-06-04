//
//  SGForeignProfileViewController.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 01/06/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit
import PromiseKit

class SGForeignProfileViewController: SGViewController {
    
    let user: SGApplicationUser
    
    var foreigner: SGUser?
    
    var userAPI: UserAPI?
    var eventAPI: EventAPI?
    
    var onEvent: ((Int) -> Void)?
    
    // MARK: - Private properties
    
    private lazy var tableView: SGSelfSizingTableView = {
        let tableView = SGSelfSizingTableView()
        
        tableView.register(SGSeparatorCell.self, forCellReuseIdentifier: SGSeparatorCell.reuseIdentifier)
        tableView.register(SGEventCell.self, forCellReuseIdentifier: SGEventCell.reuseIdentifier)
        tableView.register(SGSmallProfileCell.self, forCellReuseIdentifier: SGSmallProfileCell.reuseIdentifier)
        tableView.register(SGRatingCell.self, forCellReuseIdentifier: SGRatingCell.reuseIdentifier)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        return tableView
    }()
    
    private lazy var paginator: Paginator<SGEventInfo> = {
        let paginator = Paginator<SGEventInfo>(fetchHandler: {
            [unowned self]
            paginator, nextPage in
            
            guard let foreigner = self.foreigner else {
                return
            }
            
            self.eventAPI?.getEvents(withToken: self.user.token, page: nextPage, participantId: foreigner.id).done {
                eventsPage in
                
                self.paginator.receivedResults(results: eventsPage.events, next: eventsPage.next)
            }.catch {
                error in
                print(error)
            }
            
            }, resultsHandler: {
                [unowned self]
                paginator, old, new in
                
                self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
                
                var insertPaths: [IndexPath] = (old.count...(new.count + old.count - 1)).map {
                    return IndexPath(row: $0, section: 1)
                }
                
                self.tableView.performBatchUpdates({
                    self.tableView.insertRows(at: insertPaths, with: .automatic)
                }, completion: nil)
                
                if paginator.reachedLastPage {
                    self.removeLoadingFooter()
                } else {
                    self.showLoadingFooter()
                }
            }, refreshHandler: {
                [unowned self]
                (paginator, results) in
                
                self.tableView.endLoading()
                
                self.tableView.refreshControl?.endRefreshing()
                
                self.tableView.reloadData()
                
                if paginator.reachedLastPage {
                    self.removeLoadingFooter()
                } else {
                    self.showLoadingFooter()
                }
            }, resetHandler: {
                [unowned self]
                (paginator) in
                
                self.removeLoadingFooter()
        })
        
        return paginator
    }()
    
    // MARK: - UIViewController hierarchy
    
    init(user: SGApplicationUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.beginLoading(withOffset: -30.0)
        self.reload {
            self.tableView.endLoading()
        }

        self.view.backgroundColor = .appWhite
        self.addConstraintsToSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredNavigationBarItemsConfigurationType: UINavigationController.ItemsConfigurationType {
        return .modal
    }
    
    // MARK: - Private functions
    
    private func addConstraintsToSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }
    
    private func reload(withCompletion completon: @escaping () -> Void = {}) {
        guard
            let foreigner = self.foreigner,
            let userAPI = self.userAPI,
            let eventAPI = self.eventAPI else {
                return
        }
        
        let profileLoading = userAPI.getUser(withToken: user.token, userId: foreigner.id)
        let eventsLoading = eventAPI.getEvents(withToken: user.token, page: 1, participantId: foreigner.id)
        
        when(fulfilled: profileLoading, eventsLoading).done {
            [weak self]
            (user, eventsPage) in
            
            self?.foreigner = user
            self?.paginator.receivedResults(results: eventsPage.events, next: eventsPage.next)
            
            completon()
        }.catch {
            error in
            print(error)
            
            completon()
        }
    }
    
    private func rate() {
        guard let user = self.foreigner else {
            return
        }
        
        userAPI?.rateUser(withToken: self.user.token, userId: user.id).done {
            [weak self] user in
            
            self?.foreigner = user
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }.catch {
                error in
                print(error)
        }
    }
    
    private func unrate() {
        guard let user = self.foreigner else {
            return
        }
        
        userAPI?.unrateUser(withToken: self.user.token, userId: user.id).done {
            [weak self] user in
            
            self?.foreigner = user
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }.catch {
                error in
                print(error)
        }
    }
    
    @objc private func refresh() {
        self.paginator.reset()
        self.reload()
    }
    
    // MARK: - UITableFooterView
    
    private func showLoadingFooter() {
        let footerView = SGLoaderFooterView(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: self.view.width,
                                                          height: SGLoaderFooterView.height))
        
        footerView.animate()
        self.tableView.tableFooterView = footerView
    }
    
    private func removeLoadingFooter() {
        self.tableView.tableFooterView = UIView()
    }
}

extension SGForeignProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count: Int = 1
        
        if !paginator.results.isEmpty {
            count += 1
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            return paginator.results.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, let user = self.foreigner {
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGSmallProfileCell.reuseIdentifier,
                                                        for: indexPath) as? SGSmallProfileCell {
                cell.configure(withUser: user,
                               selectionRatingHandler: {
                                [weak self] _ in
                                self?.rate()
                },
                               unselectionRatingHandler: {
                                [weak self] _ in
                                self?.unrate()
                })
                return cell
            }
            return UITableViewCell()
        }
        
        if indexPath.section == 1 {
            let eventInfo = self.paginator.results[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGEventCell.reuseIdentifier,
                                                        for: indexPath) as? SGEventCell {
                cell.configure(withEventInfo: eventInfo, tapHandler: {
                    [weak self] _ in
                    
                    self?.onEvent?(eventInfo.id)
                })
                return cell
            }
            
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
}

extension SGForeignProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0, let user = self.foreigner {
            return SGSmallProfileCell.height(forUser: user, width: self.view.width)
        }
        
        if indexPath.section == 1 {
            let eventInfo = self.paginator.results[indexPath.row]
            return SGEventCell.height(forEventInfo: eventInfo)
        }
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = SGTitleHeaderView()
            headerView.configure(withText: "Cобытия")
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return SGTitleHeaderView.height(forText: "Ваши события", width: self.view.width)
        }
        
        return 0.01
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // when reaching bottom, load a new page
        if scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height {
            
            if paginator.reachedLastPage {
                self.paginator.fetchNextPage()
            }
        }
    }
}
