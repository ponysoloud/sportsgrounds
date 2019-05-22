//
//  SGGroundResponse.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 15/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGGroundResponse: Decodable {
    
    let status: String
    let ground: SGGround
    
    private enum CodingKeys: String, CodingKey {
        case status
        case ground
    }
}
