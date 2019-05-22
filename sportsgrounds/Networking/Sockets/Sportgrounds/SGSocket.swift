//
//  SGSocket.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 22/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

enum SGSocket: Socket {
    
    case eventMessages
    
    var namespace: String {
        switch self {
        case .eventMessages:
            return "/event/messages"
        }
    }
}
