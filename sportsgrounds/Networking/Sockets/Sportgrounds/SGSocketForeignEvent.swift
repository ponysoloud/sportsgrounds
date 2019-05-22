//
//  SGSocketForeignEvent.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 22/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

enum SGSocketForeignEvent: String, SocketForeignEvent {
    
    case joined
    case leaved
    case message
    case status
    
    var name: String {
        return self.rawValue
    }
}
