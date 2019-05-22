//
//  SGGround.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 15/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGGround: Decodable, Equatable {
    
    let id: Int
    
    let name: String
    let district: String
    let address: String
    
    let hasMusic: Bool
    let hasWifi: Bool
    let hasToilet: Bool
    let hasEatery: Bool
    let hasDressingRoom: Bool
    let hasLighting: Bool
    let paid: Bool
    
    let activities: [SGActivity]
    
    var environments: [SGEnvironment] {
        var environments: [SGEnvironment] = []
        if hasLighting {
            environments.append(.lighting)
        }
        if hasMusic {
            environments.append(.music)
        }
        if hasWifi {
            environments.append(.wifi)
        }
        if hasToilet {
            environments.append(.toilet)
        }
        if hasEatery {
            environments.append(.food)
        }
        return environments
    }
    
    let location: SGCoordinate
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case district
        case hasMusic
        case hasWifi
        case hasToilet
        case hasEatery
        case hasDressingRoom
        case hasLighting
        case paid
        case activities
        case location
    }
}
