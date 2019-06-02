//
//  SGProfileViewController.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit
import PromiseKit
import SPAlert
import YPImagePicker

class SGProfileViewController: SGViewController {
    
    let user: SGApplicationUser
    
    var authAPI: AuthAPI?
    var userAPI: UserAPI?
    var eventAPI: EventAPI?
    
    var onExit: (() -> Void)?
    var onEvent: ((Int) -> Void)?
    var onParticipant: ((SGUser) -> Void)?
    
    // MARK: - Private properties
    
    private lazy var tableView: SGSelfSizingTableView = {
        let tableView = SGSelfSizingTableView()
        
        tableView.register(SGUserCell.self, forCellReuseIdentifier: SGUserCell.reuseIdentifier)
        tableView.register(SGSeparatorCell.self, forCellReuseIdentifier: SGSeparatorCell.reuseIdentifier)
        tableView.register(SGEventCell.self, forCellReuseIdentifier: SGEventCell.reuseIdentifier)
        tableView.register(SGBigProfileCell.self, forCellReuseIdentifier: SGBigProfileCell.reuseIdentifier)
        tableView.register(SGRatingCell.self, forCellReuseIdentifier: SGRatingCell.reuseIdentifier)
        
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
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
            
            self.eventAPI?.getEvents(withToken: self.user.token, page: nextPage, participantId: self.user.user.id).done {
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
                    return IndexPath(row: $0, section: self.tableView.numberOfSections - 1)
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
    
    private var pickerConfig: YPImagePickerConfiguration {
        var config = YPImagePickerConfiguration()
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = false
        config.showsPhotoFilters = true
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = YPPickerScreen.library
        config.screens = [.library, .photo]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = true
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.library.options = nil
        config.library.onlySquare = false
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        
        return config
    }
    
    private var teammates: [SGUser] = []
    
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
        
        self.reset()
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
        
        let exitBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "user.icon.profile.exit"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(exitTouchUpInside(_:)))
        exitBarButtonItem.imageInsets = UIEdgeInsets(top: -1, left: 0, bottom: 1, right: 0)
        exitBarButtonItem.tintColor = UIColor.appBlack
        self.navigationItem.setRightBarButton(exitBarButtonItem, animated: true)
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
    
    @objc private func exitTouchUpInside(_ sender: UIBarButtonItem) {
        self.tableView.beginLoading(withOffset: -30.0)
        
        authAPI?.logout(token: user.token).done {
            [weak self] _ in
            
            self?.tableView.endLoading()
            self?.onExit?()
        }.catch {
            _ in
            SPAlert.present(message: "Непредвиденная ошибка. Попробуйте еще раз")
        }
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
    
    @objc private func refresh() {
        reset()
        reload()
    }
    
    private func reload(withCompletion completon: @escaping () -> Void = {}) {
        guard
            let userAPI = self.userAPI,
            let eventAPI = self.eventAPI else {
                return
        }

        let profileLoading = userAPI.getUser(withToken: user.token)
        let teammatesLoading = userAPI.getTeammates(withToken: user.token, userId: user.user.id, count: 10)
        let eventsLoading = eventAPI.getEvents(withToken: user.token, page: 1, participantId: user.user.id)
        
        when(fulfilled: profileLoading, teammatesLoading, eventsLoading).done {
            [weak self]
            (user, teammates, eventsPage) in
            
            self?.user.user = user
            self?.teammates = teammates
            self?.paginator.receivedResults(results: eventsPage.events, next: eventsPage.next)
            
            completon()
        }.catch {
            error in
            print(error)
            
            completon()
        }
    }
    
    private func reset() {
        self.teammates = []
        self.paginator.reset()
    }
}

extension SGProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count: Int = 1
        
        if !teammates.isEmpty {
            count += 1
        }
        
        if !paginator.results.isEmpty {
            count += 1
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            if !teammates.isEmpty {
                return teammates.count * 2 - 1
            }
            fallthrough
        case 2:
            if !paginator.results.isEmpty {
                return paginator.results.count
            }
            fallthrough
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: SGBigProfileCell.reuseIdentifier,
                                                            for: indexPath) as? SGBigProfileCell {
                    cell.configure(withUser: self.user.user) { [unowned self] cell in
                        let picker = YPImagePicker(configuration: self.pickerConfig)
                        picker.didFinishPicking { [unowned picker] items, _ in
                            if let photo = items.singlePhoto {
                                print(photo.image)
                                
                                self.userAPI?.editUser(withToken: self.user.token, image: photo.image).done {
                                    user in
                                    
                                    self.user.user = user
                                    cell.set(image: photo.image)
                                }.catch {
                                    error in
                                    print(error)
                                }
                            }
                            picker.dismiss(animated: true, completion: nil)
                        }
                        self.present(picker, animated: true, completion: nil)
                    }
                    return cell
                }
                return UITableViewCell()
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: SGRatingCell.reuseIdentifier,
                                                            for: indexPath) as? SGRatingCell {
                    cell.configure(withRating: user.user.rating, width: self.view.width)
                    return cell
                }
                return UITableViewCell()
            default:
                return UITableViewCell()
            }
        case 1:
            if !teammates.isEmpty {
                if (indexPath.row % 2 > 0) {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: SGSeparatorCell.reuseIdentifier,
                                                                for: indexPath) as? SGSeparatorCell {
                        cell.configure(withStyle: .separate)
                        return cell
                    }
                    return UITableViewCell()
                }
                
                let teammate = self.teammates[indexPath.row / 2]
                if let cell = tableView.dequeueReusableCell(withIdentifier: SGUserCell.reuseIdentifier,
                                                            for: indexPath) as? SGUserCell {
                    cell.configure(withUser: teammate,
                                   isOwner: false,
                                   isYou: false,
                                   style: .separate) { [unowned self] _ in
                                    self.onParticipant?(teammate)
                    }
                    return cell
                }
                return UITableViewCell()
            }
            fallthrough
        case 2:
            if !paginator.results.isEmpty {
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
            fallthrough
        default:
            return UITableViewCell()
        }
    }
}

extension SGProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return SGBigProfileCell.height(forUser: user.user, width: self.view.width)
            case 1:
                return SGRatingCell.height(forRating: user.user.rating, width: self.view.width)
            default:
                return 0.01
            }
        case 1:
            if !teammates.isEmpty {
                if (indexPath.row % 2 > 0) {
                    return SGSeparatorCell.height
                }
                return SGUserCell.height
            }
            fallthrough
        case 2:
            if !paginator.results.isEmpty {
                let eventInfo = self.paginator.results[indexPath.row]
                return SGEventCell.height(forEventInfo: eventInfo)
            }
            fallthrough
        default:
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            if !teammates.isEmpty {
                let headerView = SGTitleHeaderView()
                headerView.configure(withText: "Партнеры по командам")
                return headerView
            }
            fallthrough
        case 2:
            if !paginator.results.isEmpty {
                let headerView = SGTitleHeaderView()
                headerView.configure(withText: "Ваши события")
                return headerView
            }
            fallthrough
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.01
        case 1:
            if !teammates.isEmpty {
                return SGTitleHeaderView.height(forText: "Партнеры по командам", width: self.view.width)
            }
            fallthrough
        case 2:
            if !paginator.results.isEmpty {
                return SGTitleHeaderView.height(forText: "Ваши события", width: self.view.width)
            }
            fallthrough
        default:
            return 0.01
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
