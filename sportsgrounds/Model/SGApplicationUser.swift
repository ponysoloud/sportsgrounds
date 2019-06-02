//
//  SGApplicationUser.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

class SGApplicationUser {
    
    let token: String
    var user: SGUser
    
    init(token: String, user: SGUser) {
        self.token = token
        self.user = user
    }
}
