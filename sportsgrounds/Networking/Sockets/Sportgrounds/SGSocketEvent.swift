//
//  SGEvent.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 22/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

enum SGSocketEvent: SocketEvent {
    
    case join(token: String, eventId: Int)
    case leave(token: String, eventId: Int)
    case message(token: String, eventId: Int, text: String)
    
    var name: String {
        switch self {
        case .join:
            return "join"
        case .leave:
            return "leave"
        case .message:
            return "message"
        }
    }
    
    var dictionary: [String : Any] {
        switch self {
        case let .join(token: token, eventId: id):
            return ["token": token, "eventId": id]
        case let .leave(token: token, eventId: id):
            return ["token": token, "eventId": id]
        case let .message(token: token, eventId: id, text: text):
            return ["token": token, "eventId": id, "message": text]
        }
    }
}
