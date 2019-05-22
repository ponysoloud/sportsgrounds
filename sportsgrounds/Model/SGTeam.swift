//
//  SGTeam.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGTeam: Decodable {
    
    let id: Int
    let maxParticipants: Int
    let participants: [SGUser]
    
    enum CodingKeys: String, CodingKey {
        case id
        case maxParticipants
        case participants
    }
}
