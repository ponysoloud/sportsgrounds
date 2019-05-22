//
//  SGTokenResponse.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 15/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGTokenResponse: Decodable {
    
    let status: String
    let token: String
    
    private enum CodingKeys: String, CodingKey {
        case status
        case token = "auth_token"
    }
}
