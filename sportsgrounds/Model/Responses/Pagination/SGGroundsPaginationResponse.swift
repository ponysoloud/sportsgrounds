//
//  SGGroundsPaginationResponse.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 15/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGGroundsPaginationResponse: Decodable {
    
    let status: String
    let previous: String?
    let next: String?
    let count: Int
    let grounds: [SGGround]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case previous
        case next
        case count
        case grounds
    }
}
