//
//  SGUsersResponse.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 23/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGUsersResponse: Decodable, Parsable {
    
    let status: String
    let users: [SGUser]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case users
    }
}
