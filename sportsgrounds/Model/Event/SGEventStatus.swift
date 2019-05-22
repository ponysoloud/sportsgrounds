//
//  SGEventStatus.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

enum SGEventStatus: Int, Decodable {
    case processing = 1
    case scheduled
    case ended
    case canceled
    
    var title: String {
        switch self {
        case .processing:
            return "Запланированно"
        case .scheduled:
            return "В процессе"
        case .ended:
            return "Завершилось"
        case .canceled:
            return "Отменено"
        }
    }
}
