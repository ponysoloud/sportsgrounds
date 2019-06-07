//
//  SGEventChatViewController.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 21/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit
import KeyboardLayoutGuide

class SGEventChatViewController: SGViewController {
    
    let user: SGApplicationUser
    
    var eventId: Int?
    var eventAPI: EventAPI?
    var socketsProvider: SocketsProvider?
    
    var onEvent: ((Int) -> Void)?
    var onParticipant: ((SGUser) -> Void)?
    
    // MARK: - Private properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(SGIncomeMessageCell.self, forCellReuseIdentifier: SGIncomeMessageCell.reuseIdentifier)
        tableView.register(SGOutcomeMessageCell.self, forCellReuseIdentifier: SGOutcomeMessageCell.reuseIdentifier)
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        return tableView
    }()
    
    private lazy var bottomView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.appWhite
        
        view.addSubview(footerView)
        return footerView
    }()
    
    private lazy var messageTextView: SGTextView = {
        let textView = SGTextView.textView
        textView.placeholder = "Сообщение"
        
        bottomView.addSubview(textView)
        return textView
    }()
    
    private lazy var sendMessageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "event.message.icon.send"), for: .normal)
        button.addTarget(self, action: #selector(sendMessageButtonTouchUpInside(_:)), for: .touchUpInside)
        
        bottomView.addSubview(button)
        return button
    }()
    
    private var chatManager: SGEventChatManager?
    
    private var messages: [SGMessage] = []
    private var hasNext: Bool = false
    
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
        
        self.title = "Чат"
        
        self.view.backgroundColor = .appWhite
        
        self.addConstraintsToSubviews()
        self.addGestureRecognizerForHidingKeyboardOnTap()
        
        if let socketsProvider = self.socketsProvider {
            self.chatManager = SGEventChatManager(
                provider: socketsProvider,
                joinedHandler: { (user) in
                    print(user)
            },
                leavedHandler: { (user) in
                    print(user)
            },
                statusHandler: { (status) in
                    print(status)
            },
                messageHandler: { (message) in
                    self.messages.insert(message, at: 0)
                    
                    self.tableView.performBatchUpdates({
                        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                    }, completion: nil)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reload()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let eventId = self.eventId {
            self.chatManager?.leave(withToken: self.user.token, fromEventRoom: eventId, withCompletion: {})
        }
    }
    
    override var preferredNavigationBarItemsConfigurationType: UINavigationController.ItemsConfigurationType {
        return .modal
    }
    
    // MARK: - Simple requests for loading messages history
    
    func reload() {
        guard let eventId = self.eventId else {
            return
        }
        
        self.reset()
        self.tableView.beginLoading(withOffset: -30.0)
        
        eventAPI?.getEventMessages(withToken: user.token, skip: 0, count: 8, eventId: eventId).done {
            [unowned self]
            messagesPage in
            
            self.tableView.endLoading()
            
            self.messages = messagesPage.messages
            self.hasNext = messagesPage.next != nil
            
            if self.hasNext {
                self.showLoadingFooter()
            } else {
                self.removeLoadingFooter()
            }
            
            self.tableView.reloadData()
            self.chatManager?.join(withToken: self.user.token, toEventRoom: eventId, withCompletion: {})
        }.catch {
            [unowned self]
            error in
            print(error)
            
            self.removeLoadingFooter()
        }
    }
    
    func loadNext() {
        guard let eventId = self.eventId else {
            return
        }
        
        eventAPI?.getEventMessages(withToken: user.token, skip: messages.count, count: 8, eventId: eventId).done {
            [unowned self]
            messagesPage in
            
            let old = self.messages
            let new = messagesPage.messages
            
            self.messages.append(contentsOf: new)
            self.hasNext = messagesPage.next != nil
            
            self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
            
            let insertPaths: [IndexPath] = (old.count...(new.count + old.count - 1)).map {
                return IndexPath(row: $0, section: 0)
            }
            
            self.tableView.performBatchUpdates({
                self.tableView.insertRows(at: insertPaths, with: .bottom)
            }, completion: nil)
            
            if self.hasNext {
                self.showLoadingFooter()
            } else {
                self.removeLoadingFooter()
            }
            }.catch {
                [unowned self]
                error in
                print(error)
                
                self.removeLoadingFooter()
        }
    }
    
    func reset() {
        self.messages = []
        self.hasNext = false
    }
    
    // MARK: - Private functions
    
    private func addConstraintsToSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        sendMessageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            bottomView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            bottomView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            bottomView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            messageTextView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10),
            messageTextView.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 10),
            messageTextView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -15),
            messageTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),
            
            sendMessageButton.leftAnchor.constraint(equalTo: messageTextView.rightAnchor, constant: 20),
            sendMessageButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -18),
            sendMessageButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -20),
            sendMessageButton.heightAnchor.constraint(equalTo: sendMessageButton.widthAnchor),
            sendMessageButton.widthAnchor.constraint(equalToConstant: 30)
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
    
    // MARK: - Button Events
    
    @objc private func sendMessageButtonTouchUpInside(_ sender: UIButton) {
        if let eventId = self.eventId, let message = self.messageTextView.regularText {
            self.messageTextView.text = ""
            self.chatManager?.sendMessage(withToken: user.token, toEventRoom: eventId, message: message, withCompletion: {})
        }
    }
}

extension SGEventChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        
        if message.sender.id == self.user.user.id {
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGOutcomeMessageCell.reuseIdentifier,
                                                        for: indexPath) as? SGOutcomeMessageCell {
                cell.configure(withMessage: message)
                cell.transform = CGAffineTransform(scaleX: 1, y: -1)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: SGIncomeMessageCell.reuseIdentifier,
                                                        for: indexPath) as? SGIncomeMessageCell {
                cell.configure(withMessage: message) {
                    [unowned self] _ in
                    self.onParticipant?(message.sender)
                }
                cell.transform = CGAffineTransform(scaleX: 1, y: -1)
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension SGEventChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = self.messages[indexPath.row]
        
        if message.sender.id == self.user.user.id {
            return SGOutcomeMessageCell.height(forMessage: message, width: self.view.width)
        } else {
            return SGIncomeMessageCell.height(forMessage: message, width: self.view.width)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // when reaching bottom, load a new page
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height, scrollView.contentOffset.y > 0 {
            
            if self.hasNext {
                self.loadNext()
            }
        }
    }
}
