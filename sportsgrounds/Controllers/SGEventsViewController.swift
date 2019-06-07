//
//  SGEventsViewController.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGEventsViewController: SGViewController {
    
    let user: SGApplicationUser
    
    var eventAPI: EventAPI?
    var onEvent: ((Int) -> Void)?
    
    // MARK: - Private properties
    
    private lazy var tableView: SGSelfSizingTableView = {
        let tableView = SGSelfSizingTableView()
        
        tableView.register(SGEventCell.self, forCellReuseIdentifier: SGEventCell.reuseIdentifier)
        
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
            
            self.eventAPI?.getEvents(withToken: self.user.token, page: nextPage).done {
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
            
            let insertPaths: [IndexPath] = (old.count...(new.count + old.count - 1)).map {
                return IndexPath(row: $0, section: 0)
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
            
            self.tableView.refreshControl?.endRefreshing()
            
            self.tableView.endLoading()
            self.tableView.reloadData()
            
            if paginator.reachedLastPage {
                self.removeLoadingFooter()
            } else {
                self.showLoadingFooter()
            }
        }, resetHandler: {
            [unowned self]
            (paginator) in
            
            self.tableView.reloadData()
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
        
        self.reload()
        self.view.backgroundColor = .appWhite
        self.addConstraintsToSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    // MARK: - Operations with whole table view
    
    func reload() {
        self.paginator.reset()
        
        self.tableView.beginLoading(withOffset: -30.0)
        self.paginator.refresh()
    }
    
    @objc private func refresh() {
        self.paginator.refresh()
    }
}

extension SGEventsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paginator.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}

extension SGEventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let eventInfo = self.paginator.results[indexPath.row]
        return SGEventCell.height(forEventInfo: eventInfo)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // when reaching bottom, load a new page
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height, scrollView.contentOffset.y > 0 {
            
            if !self.paginator.reachedLastPage {
                self.paginator.fetchNextPage()
            }
        }
    }
}
