//
//  SGEventResponse.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 18/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGEventResponse: Decodable {
    
    let status: String
    let event: SGEvent
    
    private enum CodingKeys: String, CodingKey {
        case status
        case event
    }
}
