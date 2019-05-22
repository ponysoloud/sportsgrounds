//
//  SocketEvent.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 22/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

protocol SocketEvent {
    
    var name: String { get }
    
    var dictionary: [String: Any] { get }
}
