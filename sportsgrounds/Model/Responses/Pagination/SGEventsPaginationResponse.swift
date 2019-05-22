//
//  SGEventsPaginationResponse.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGEventsPaginationResponse: Decodable {
    
    let status: String
    let previous: String?
    let next: String?
    let count: Int
    let events: [SGEventInfo]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case previous
        case next
        case count
        case events
    }
}
