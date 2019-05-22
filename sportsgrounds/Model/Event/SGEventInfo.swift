//
//  SGEventInfo.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

class SGEventInfo: Decodable {
    
    let id: Int
    
    let title: String
    let description: String
    
    let status: SGEventStatus
    let activity: SGActivity
    
    let groundId: Int
    let ownerId: Int
    
    let type: SGEventType
    
    let requiredLevel: SGParticipantsLevel
    let requiredAgeFrom: Int
    let requiredAgeTo: Int
    
    let beginAt: Date
    let endAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case status
        case activity
        case groundId
        case ownerId
        case type
        case requiredLevel
        case requiredAgeFrom
        case requiredAgeTo
        case beginAt
        case endAt
    }
}
