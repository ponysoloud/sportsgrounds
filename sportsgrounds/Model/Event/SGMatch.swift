//
//  SGMatch.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

class SGMatch: Decodable {
    
    let scoreA: Int?
    let scoreB: Int?
    
    let teamA: SGTeam
    let teamB: SGTeam
    
    enum CodingKeys: String, CodingKey {
        case scoreA
        case scoreB
        case teamA
        case teamB
    }
}
