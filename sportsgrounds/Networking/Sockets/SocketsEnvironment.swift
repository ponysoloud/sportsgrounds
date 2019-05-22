//
//  SocketsEnvironment.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 22/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation
import SocketIO

protocol SocketsEnvironment {
    
    var host: URL { get }
    
    var parameters: SocketIOClientConfiguration { get }
}
