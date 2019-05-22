//
//  SGActivity.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation
import UIKit

enum SGActivity: Int, Decodable, Equatable, CaseIterable, SGCaseNameable {
    case easyTraining = 1
    case football
    case hockey
    case basketball
    case skating
    case iceSkating
    case workout
    case yoga
    case box
    
    var title: String {
        switch self {
        case .easyTraining:
            return "Легкая тренировка"
        case .football:
            return "Футбол"
        case .hockey:
            return "Хоккей"
        case .basketball:
            return "Баскетбол"
        case .skating:
            return "Катание на роликах"
        case .iceSkating:
            return "Катание на коньках"
        case .workout:
            return "Воркаут"
        case .yoga:
            return "Йога"
        case .box:
            return "Бокс"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .easyTraining:
            return #imageLiteral(resourceName: "activity.icon.easy")
        case .football:
            return #imageLiteral(resourceName: "activity.icon.football")
        case .hockey:
            return #imageLiteral(resourceName: "activity.icon.hockey")
        case .basketball:
            return #imageLiteral(resourceName: "activity.icon.basketball")
        case .skating:
            return #imageLiteral(resourceName: "activity.icon.skating")
        case .iceSkating:
            return #imageLiteral(resourceName: "activity.icon.ice_skating")
        case .workout:
            return #imageLiteral(resourceName: "activity.icon.workout")
        case .yoga:
            return #imageLiteral(resourceName: "activity.icon.yoga")
        case .box:
            return #imageLiteral(resourceName: "activity.icon.box")
        }
    }
    
    var accessibleEventTypes: [SGEventType] {
        switch self {
        case .easyTraining:
            return [.training]
        case .football:
            return SGEventType.allCases
        case .hockey:
            return SGEventType.allCases
        case .basketball:
            return SGEventType.allCases
        case .skating:
            return [.training]
        case .iceSkating:
            return [.training]
        case .workout:
            return [.training]
        case .yoga:
            return [.training]
        case .box:
            return [.training]
        }
    }
}
