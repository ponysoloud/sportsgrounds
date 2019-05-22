//
//  SGParticipantsLevel.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

enum SGParticipantsLevel: Int, Decodable, Equatable, CaseIterable, SGCaseNameable {
    case beginner = 1
    case average
    case experienced
    case expert
    case any
    
    var title: String {
        switch self {
        case .beginner:
            return "Начинающий"
        case .average:
            return "Средний"
        case .experienced:
            return "Опытный"
        case .expert:
            return "Профессионал"
        case .any:
            return "Любой"
        }
    }
}
