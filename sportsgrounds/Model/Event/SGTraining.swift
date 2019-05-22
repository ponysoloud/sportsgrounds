//
//  SGTraining.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

class SGTraining: Decodable {
    
    let team: SGTeam
    
    enum CodingKeys: String, CodingKey {
        case team
    }
}
