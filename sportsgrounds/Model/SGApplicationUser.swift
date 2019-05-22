//
//  SGApplicationUser.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

class SGApplicationUser {
    
    static var shared: SGApplicationUser?
    
    static func save(withToken token: String, user: SGUser) -> SGApplicationUser {
        let applicationUser = SGApplicationUser(token: token, user: user)
        shared = applicationUser
        return applicationUser
    }
    
    let token: String
    let user: SGUser
    
    private init(token: String, user: SGUser) {
        self.token = token
        self.user = user
    }
}
