//
//  SGGroundViewController.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit
import PromiseKit

class SGGroundViewController: SGViewController {
    
    let user: SGApplicationUser
    
    var groundId: Int?
    
    var groundAPI: GroundAPI?
    var eventAPI: EventAPI?
    
    var onEvent: ((Int) -> Void)?
    var onAddEvent: ((SGGround) -> Void)?
    
    // MARK: - Private properties
    
    private lazy var tableView: SGSelfSizingTableView = {
        let tableView = SGSelfSizingTableView()
        
        tableView.register(SGGroundCell.self, forCellReuseIdentifier: SGGroundCell.reuseIdentifier)
        tableView.register(SGEventCell.self, forCellReuseIdentifier: SGEventCell.reuseIdentifier)
        tableView.register(SGBorderedButtonCell.self, forCellReuseIdentifier: SGBorderedButtonCell.reuseIdentifier)
 
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        return tableView
    }()
    
    private var ground: SGGround?
    
    private lazy var paginator: Paginator<SGEventInfo> = {
        let paginator = Paginator<SGEventInfo>(fetchHandler: {
            [unowned self]
            paginator, nextPage in
            
            self.eventAPI?.getEvents(withToken: self.user.token, page: nextPage, groundId: self.groundId).done {
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
        
        self.title = "Площадка"

        self.view.backgroundColor = .appWhite
        
        self.addConstraintsToSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reload()
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
        guard
            let groundAPI = self.groundAPI,
            let eventAPI = self.eventAPI,
            let groundId = self.groundId else {
            return
        }
        
        self.reset()
        self.tableView.beginLoading(withOffset: -30.0)
        
        let groundLoading = groundAPI.getGroundDetails(withToken: user.token, groundId: groundId)
        let eventsLoading = eventAPI.getEvents(withToken: user.token, page: 1, groundId: groundId)
        
        when(fulfilled: groundLoading, eventsLoading).done {
            [weak self]
            (ground, eventsPage) in
            
            self?.tableView.endLoading()
            
            self?.ground = ground
            self?.paginator.receivedResults(results: eventsPage.events, next: eventsPage.next)
        }.catch {
            [weak self]
            error in
            print(error)
        }
    }
    
    func reset() {
        self.ground = nil
        self.paginator.reset()
    }
}

extension SGGroundViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = self.ground {
            return 2
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if self.paginator.results.count > 0 {
            return self.paginator.results.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let ground = self.ground, let cell = tableView.dequeueReusableCell(withIdentifier: SGGroundCell.reuseIdentifier,
                                                                                  for: indexPath) as? SGGroundCell {
                cell.configure(withGround: ground, style: .separate, tapHandler: { _ in })
                return cell
            }
            
            return UITableViewCell()
        }
        
        if self.paginator.results.count > 0 {
            let eventInfo = self.paginator.results[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGEventCell.reuseIdentifier,
                                                        for: indexPath) as? SGEventCell {
                cell.configure(withEventInfo: eventInfo, tapHandler: {
                    [weak self] _ in
                    
                    self?.onEvent?(eventInfo.id)
                })
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGBorderedButtonCell.reuseIdentifier,
                                                        for: indexPath) as? SGBorderedButtonCell {
                cell.configure(withTitle: "Добавить", tapHandler: {
                    [weak self]
                    _ in
                    
                    if let ground = self?.ground {
                        self?.onAddEvent?(ground)
                    }
                })
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension SGGroundViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let ground = self.ground {
                return SGGroundCell.height(forGround: ground, width: self.view.width)
            }
            return 0.01
        }
        
        if self.paginator.results.count > 0 {
            let eventInfo = self.paginator.results[indexPath.row]
            return SGEventCell.height(forEventInfo: eventInfo)
        } else {
            return SGBorderedButtonCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        if self.paginator.results.count > 0 {
            let headerView = SGTitleButtonHeaderView()
            headerView.configure(withText: "События на этой площадке", tapHandler: {
                [weak self]
                _ in
                
                if let ground = self?.ground {
                    self?.onAddEvent?(ground)
                }
            })
            
            return headerView
        } else {
            let headerView = SGSubtitleHeaderView()
            headerView.configure(withText: "Событий на этой спортивной площадке еще не проводилось")
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        
        if self.paginator.results.count > 0 {
            return SGTitleButtonHeaderView.height(forText: "События на этой площадке", width: self.view.width)
        } else {
            return SGSubtitleHeaderView.height(forText: "Событий на этой спортивной площадке еще не проводилось", width: self.view.width)
        }
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
