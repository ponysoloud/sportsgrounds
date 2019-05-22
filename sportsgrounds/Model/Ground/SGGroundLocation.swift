//
//  SGGroundLocation.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 15/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGGroundLocation: Decodable {
    
    let id: Int
    let status: SGEventStatus?
    let location: SGCoordinate
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case location
    }
}
