//
//  SGEventType.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

enum SGEventType: Int, Decodable, CaseIterable, SGCaseNameable {
    case training = 1
    case match
    case tourney
    
    var title: String {
        switch self {
        case .training:
            return "Тренировка"
        case .match:
            return "Простая игра"
        case .tourney:
            return "Турнир"
        }
    }
}
