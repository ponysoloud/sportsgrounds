//
//  SGEnvironment.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation
import UIKit

enum SGEnvironment {
    case lighting
    case food
    case toilet
    case wifi
    case music
    
    var icon: UIImage {
        switch self {
        case .lighting:
            return #imageLiteral(resourceName: "environment.icon.lighting")
        case .food:
            return #imageLiteral(resourceName: "environment.icon.food")
        case .toilet:
            return #imageLiteral(resourceName: "environment.icon.toilet")
        case .wifi:
            return #imageLiteral(resourceName: "environment.icon.wifi")
        case .music:
            return #imageLiteral(resourceName: "environment.icon.music")
        }
    }
}
