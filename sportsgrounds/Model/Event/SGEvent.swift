//
//  SGEvent.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

class SGEvent: Decodable {
    
    let id: Int
    
    let title: String
    let description: String
    
    let status: SGEventStatus
    let activity: SGActivity
    
    let ground: SGGround
    let owner: SGUser
    
    let type: SGEventType
    
    let training: SGTraining?
    let match: SGMatch?
    let tourney: SGTourney?
    
    let requiredLevel: SGParticipantsLevel
    let requiredAgeFrom: Int
    let requiredAgeTo: Int
    
    let participated: Bool?
    
    let beginAt: Date
    let endAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case status
        case activity
        case ground
        case owner
        case type
        case training
        case match
        case tourney
        case requiredLevel
        case requiredAgeFrom
        case requiredAgeTo
        case participated
        case beginAt
        case endAt
    }
}
