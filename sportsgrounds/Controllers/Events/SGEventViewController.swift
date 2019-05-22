//
//  SGEventViewController.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 17/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit
import SPAlert

class SGEventViewController: SGViewController {
    
    let user: SGApplicationUser
    
    var eventId: Int?
    var eventAPI: EventAPI?
    
    var onChat: ((Int) -> Void)?
    var onParticipant: ((SGUser) -> Void)?
    var onGround: ((Int) -> Void)?
    var onMap: ((SGCoordinate) -> Void)?
    
    // MARK: - Private properties
    
    private lazy var tableView: SGSelfSizingTableView = {
        let tableView = SGSelfSizingTableView()
        
        tableView.register(SGGroundCell.self, forCellReuseIdentifier: SGGroundCell.reuseIdentifier)
        tableView.register(SGMapCell.self, forCellReuseIdentifier: SGMapCell.reuseIdentifier)
        tableView.register(SGEventCell.self, forCellReuseIdentifier: SGEventCell.reuseIdentifier)
        tableView.register(SGEventDescriptionCell.self, forCellReuseIdentifier: SGEventDescriptionCell.reuseIdentifier)
        tableView.register(SGEventDetailsCell.self, forCellReuseIdentifier: SGEventDetailsCell.reuseIdentifier)
        tableView.register(SGTeamCell.self, forCellReuseIdentifier: SGTeamCell.reuseIdentifier)
        tableView.register(SGUserCell.self, forCellReuseIdentifier: SGUserCell.reuseIdentifier)
        tableView.register(SGButtonCell.self, forCellReuseIdentifier: SGButtonCell.reuseIdentifier)
        tableView.register(SGSeparatorCell.self, forCellReuseIdentifier: SGSeparatorCell.reuseIdentifier)
        tableView.register(SGTextCell.self, forCellReuseIdentifier: SGTextCell.reuseIdentifier)
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        return tableView
    }()
    
    private lazy var dataSourceProvider: SGEventDataSourceProvider = {
        let provider = SGEventDataSourceProvider(userId: self.user.user.id)
        return provider
    }()
    
    private var chatBarButtonItem: UIBarButtonItem?
    private var leaveBarButtonItem: UIBarButtonItem?
    
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
        
        self.title = "Событие"
        
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
    
    private func reload() {
        guard let eventId = self.eventId else {
            return
        }
        
        self.tableView.beginLoading(withOffset: -30.0)
        
        eventAPI?.getEvent(withToken: user.token, eventId: eventId).done {
            [weak self]
            event in
            
            self?.tableView.endLoading()
            
            self?.dataSourceProvider.update(withEvent: event)
            self?.tableView.reloadData()
            
            self?.updateNavigationBar(withEvent: event)
        }.catch {
            error in
            print(error)
        }
    }
    
    private func join(toTeam teamId: Int) {
        guard let eventId = self.eventId else {
            return
        }
        
        self.tableView.beginLoading(withOffset: -30.0)
        
        eventAPI?.joinToEvent(withToken: user.token, eventId: eventId, teamId: teamId).done {
            [weak self]
            event in
            
            self?.tableView.endLoading()
            
            self?.dataSourceProvider.update(withEvent: event)
            self?.tableView.reloadData()
            
            self?.updateNavigationBar(withEvent: event)
        }.catch {
            [weak self]
            error in
            
            self?.tableView.endLoading()
            
            guard
                let serverError = error as? SportsgroundsResponseError,
                case let .serverFailureResponse(message: message) = serverError
                else {
                    return SPAlert.present(message: "Какие-то проблемы с подключением")
            }
            
            switch message {
            case "User's age does't meet the requirements of the event":
                SPAlert.present(message: "К сожалению вы не удовлетворяете условиям события")
            case "Team is full":
                SPAlert.present(message: "Команда полная! Выберите другую")
            default:
                return SPAlert.present(message: "Неизвестная ошибка")
            }
        }
    }
    
    private func leave(completionHandler: @escaping () -> Void) {
        guard let eventId = self.eventId else {
            return
        }
        
        self.tableView.beginLoading(withOffset: -30.0)
        
        eventAPI?.leaveFromEvent(withToken: user.token, eventId: eventId).done {
            [weak self]
            event in
            
            self?.tableView.endLoading()
            
            self?.dataSourceProvider.update(withEvent: event)
            self?.tableView.reloadData()
            
            self?.updateNavigationBar(withEvent: event)
            
            completionHandler()
        }.catch {
            [weak self]
            error in
            
            self?.tableView.endLoading()
            completionHandler()
            
            SPAlert.present(message: "Неизвестная ошибка")
        }
    }
    
    private func updateNavigationBar(withEvent event: SGEvent) {
        if let chatBarButtonItem = self.chatBarButtonItem,
            let leaveBarButtonItem = self.leaveBarButtonItem {
            
            if !(event.participated ?? false) {
                let rightBarButtonItems = self.navigationItem.rightBarButtonItems?.filter {
                    $0 != chatBarButtonItem && $0 != leaveBarButtonItem
                }
                self.chatBarButtonItem = nil
                self.leaveBarButtonItem = nil
                self.navigationItem.setRightBarButtonItems(rightBarButtonItems, animated: true)
            }
        } else {
            if (event.participated ?? false) {
                let leaveBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "event.icon.exit"),
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(leaveTouchUpInside(_:)))
                leaveBarButtonItem.imageInsets = UIEdgeInsets(top: -1, left: 0, bottom: 1, right: 0)
                leaveBarButtonItem.tintColor = UIColor.appBlack
                self.leaveBarButtonItem = leaveBarButtonItem
                
                let chatBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "event.icon.chat"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(chatTouchUpInside(_:)))
                chatBarButtonItem.tintColor = UIColor.appBlack
                self.chatBarButtonItem = chatBarButtonItem
                
                var rightBarButtonItems = self.navigationItem.rightBarButtonItems ?? []
                rightBarButtonItems.append([chatBarButtonItem, leaveBarButtonItem])
                
                self.navigationItem.setRightBarButtonItems(rightBarButtonItems, animated: true)
            }
        }
    }
    
    @objc private func leaveTouchUpInside(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        self.leave {
            sender.isEnabled = true
        }
    }
    
    @objc private func chatTouchUpInside(_ sender: UIBarButtonItem) {
        if let eventId = self.eventId {
            self.onChat?(eventId)
        }
    }
}

extension SGEventViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSourceProvider.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceProvider.rowItems(forSection: section).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.dataSourceProvider.rowItem(forIndexPath: indexPath) else {
            return UITableViewCell()
        }
        
        switch item {
        case let .map(ground):
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGMapCell.reuseIdentifier,
                                                        for: indexPath) as? SGMapCell {
                
                let size = SGMapCell.mapSize(forWidth: self.view.width)
                let url = MapSnapshotProvider.snapshotUrl(withSize: size,
                                                          markerLocation: (latitude: ground.location.latitude,
                                                                           longitude: ground.location.longitude))
                
                if let url = url {
                    cell.configure(withSnapshotUrl: url, style: .grouped) {
                        [unowned self] _ in
                        self.onMap?(ground.location)
                    }
                    return cell
                }
            }
        case let .ground(ground):
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGGroundCell.reuseIdentifier,
                                                        for: indexPath) as? SGGroundCell {
                cell.configure(withGround: ground, style: .grouped, tapHandler: {
                    [unowned self] _ in
                    self.onGround?(ground.id)
                })
                return cell
            }
        case let .description(text):
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGEventDescriptionCell.reuseIdentifier,
                                                        for: indexPath) as? SGEventDescriptionCell {
                cell.configure(withText: text)
                return cell
            }
        case let .eventDetails(event):
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGEventDetailsCell.reuseIdentifier,
                                                        for: indexPath) as? SGEventDetailsCell {
                cell.configure(withEvent: event)
                return cell
            }
        case let .team(team, index):
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGTeamCell.reuseIdentifier,
                                                        for: indexPath) as? SGTeamCell {
                cell.configure(withTeam: team, index: index)
                return cell
            }
        case let .user(user, isOwner: isOwner, isYou: isYou):
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGUserCell.reuseIdentifier,
                                                        for: indexPath) as? SGUserCell {
                cell.configure(withUser: user, isOwner: isOwner, isYou: isYou, style: .grouped, tapHandler: {
                    [unowned self] _ in
                    self.onParticipant?(user)
                })
                return cell
            }
        case let .text(text):
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGTextCell.reuseIdentifier,
                                                        for: indexPath) as? SGTextCell {
                cell.configure(withText: text)
                return cell
            }
        case .separator:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGSeparatorCell.reuseIdentifier,
                                                        for: indexPath) as? SGSeparatorCell {
                cell.configure(withStyle: .grouped)
                return cell
            }
        case let .button(title, teamId: id):
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGButtonCell.reuseIdentifier,
                                                        for: indexPath) as? SGButtonCell {
                cell.configure(withTitle: title, style: .grouped, tapHandler: {
                    [unowned self] _ in
                    self.join(toTeam: id)
                })
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension SGEventViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = self.dataSourceProvider.rowItem(forIndexPath: indexPath) else {
            return 0.01
        }
        
        switch item {
        case let .ground(ground):
            return SGGroundCell.height(forGround: ground, width: self.view.width)
        case .map:
            return SGMapCell.height
        case let .description(text):
            return SGEventDescriptionCell.height(forText: text, width: self.view.width)
        case .eventDetails:
            return SGEventDetailsCell.height
        case .team:
            return SGTeamCell.height
        case .user:
            return SGUserCell.height
        case let .text(text):
            return SGTextCell.height(forText: text, width: self.view.width)
        case .separator:
            return SGSeparatorCell.height
        case .button:
            return SGButtonCell.height
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = self.dataSourceProvider.headerItem(forSection: section) else {
            return nil
        }
        
        switch item {
        case let .title(text):
            let header = SGTitleHeaderView()
            header.configure(withText: text)
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let item = self.dataSourceProvider.headerItem(forSection: section) else {
            return 0.01
        }
        
        switch item {
        case let .title(text):
            return SGTitleHeaderView.height(forText: text, width: self.view.width)
        }
    }
}
