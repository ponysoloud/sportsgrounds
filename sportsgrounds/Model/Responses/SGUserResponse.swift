//
//  SGUserResponse.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGUserResponse: Decodable, Parsable {
    
    let status: String
    let user: SGUser
    
    private enum CodingKeys: String, CodingKey {
        case status
        case user
    }
}
