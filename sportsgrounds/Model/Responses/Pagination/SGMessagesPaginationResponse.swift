//
//  SGMessagesPaginationResponse.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 21/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGMessagesPaginationResponse: Decodable {
    
    let status: String
    let previous: String?
    let next: String?
    let count: Int
    let skip: Int
    let messages: [SGMessage]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case previous
        case next
        case count
        case skip
        case messages
    }
}
