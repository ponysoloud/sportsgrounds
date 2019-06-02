//
//  SGEventChatManager.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 21/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation
import SocketIO

class SGEventChatManager {
    
    typealias JoinedEventHandler = (SGUser) -> Void
    typealias LeavedEventHandler = (SGUser) -> Void
    typealias StatusEventHandler = (String) -> Void
    typealias MessageEventHandler = (SGMessage) -> Void
    
    
    let provider: SocketsProvider
    
    var joinedHandler: JoinedEventHandler
    var leavedHandler: LeavedEventHandler
    var statusHandler: StatusEventHandler
    var messageHandler: MessageEventHandler
    
    required init(provider: SocketsProvider,
                  joinedHandler: @escaping JoinedEventHandler,
                  leavedHandler: @escaping LeavedEventHandler,
                  statusHandler: @escaping StatusEventHandler,
                  messageHandler: @escaping MessageEventHandler) {
        
        self.provider = provider
        self.joinedHandler = joinedHandler
        self.leavedHandler = leavedHandler
        self.statusHandler = statusHandler
        self.messageHandler = messageHandler
        self.initiateEventsListening()
    }
    
    // MARK: - Public functions
    
    func join(withToken token: String, toEventRoom eventId: Int, withCompletion completion: @escaping () -> Void) {
        self.provider.send(event: SGSocketEvent.join(token: token, eventId: eventId),
                           withSocket: SGSocket.eventMessages,
                           withCompletion: completion)
    }
    
    func leave(withToken token: String, fromEventRoom eventId: Int, withCompletion completion: @escaping () -> Void) {
        self.provider.send(event: SGSocketEvent.leave(token: token, eventId: eventId),
                           withSocket: SGSocket.eventMessages,
                           withCompletion: completion)
    }
    
    func sendMessage(withToken token: String, toEventRoom eventId: Int, message: String, withCompletion completion: @escaping () -> Void) {
        self.provider.send(event: SGSocketEvent.message(token: token, eventId: eventId, text: message),
                           withSocket: SGSocket.eventMessages,
                           withCompletion: completion)
    }
    
    // MARK: - Private functions
    
    private func initiateEventsListening() {
        self.provider.listen(socket: SGSocket.eventMessages,
                             forEvent: SGSocketForeignEvent.joined,
                             withHandler: { data in
                                if let userResponse = try? SGUserResponse(from: data) {
                                    self.joinedHandler(userResponse.user)
                                }
        })
        
        self.provider.listen(socket: SGSocket.eventMessages,
                             forEvent: SGSocketForeignEvent.leaved,
                             withHandler: { data in
                                if let userResponse = try? SGUserResponse(from: data) {
                                    self.leavedHandler(userResponse.user)
                                }
        })
        
        self.provider.listen(socket: SGSocket.eventMessages,
                             forEvent: SGSocketForeignEvent.message,
                             withHandler: { data in
                                if let messageResponse = try? SGMessageResponse(from: data) {
                                    self.messageHandler(messageResponse.newMessage)
                                }
        })
        
        self.provider.listen(socket: SGSocket.eventMessages,
                             forEvent: SGSocketForeignEvent.status,
                             withHandler: { data in
                                if let basicResponse = try? SGBasicResponse(from: data) {
                                    self.statusHandler(basicResponse.message)
                                }
        })
    }
}
