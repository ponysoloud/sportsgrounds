//
//  SGEventPhrase.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

class SGEventPhrase {
    
    let activity: SGActivity
    let eventType: SGEventType
    
    init(activity: SGActivity, eventType: SGEventType) {
        self.activity = activity
        self.eventType = eventType
    }
    
    var phrase: String {
        switch activity {
        case .football:
            switch eventType {
            case .training:
                return "Тренировка по футболу"
            case .match:
                return "Футбольный матч"
            case .tourney:
                return "Футбольный турнир"
            }
        case .hockey:
            switch eventType {
            case .training:
                return "Тренировка по хоккею"
            case .match:
                return "Хоккейный матч"
            case .tourney:
                return "Хоккейный турнир"
            }
        case .basketball:
            switch eventType {
            case .training:
                return "Тренировка по баскетболу"
            case .match:
                return "Баскетбольный матч"
            case .tourney:
                return "Баскетбольный турнир"
            }
        case .yoga:
            return "Занятие йогой"
        case .box:
            return "Тренировка по боксу"
        default:
            return activity.title
        }
    }
}
