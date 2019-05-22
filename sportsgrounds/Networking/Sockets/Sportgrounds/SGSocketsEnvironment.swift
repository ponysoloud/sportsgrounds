//
//  SGSocketsEnvironment.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 22/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation
import SocketIO

struct SGSocketsEnvironment: SocketsEnvironment {
    
    var host: URL {
        return URL(string: "http://127.0.0.1:5000")!
    }
    
    var parameters: SocketIOClientConfiguration {
        return [.reconnectAttempts(10)]
    }
}
