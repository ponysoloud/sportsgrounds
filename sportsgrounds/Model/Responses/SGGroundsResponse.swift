//
//  SGGroundsResponse.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 15/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGGroundsResponse: Decodable {
    
    let status: String
    let grounds: [SGGroundLocation]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case grounds
    }
}
