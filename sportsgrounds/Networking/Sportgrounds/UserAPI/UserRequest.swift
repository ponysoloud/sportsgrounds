//
//  UserRequest.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation
import UIKit

enum UserRequest: Request {
    
    case getUser(token: String, userId: Int?)
    case editUser(token: String, image: UIImage)
    case getTeammates(token: String, userId: Int)

    case rateUser(token: String, userId: Int)
    case unrateUser(token: String, userId: Int)
    
    var path: String {
        switch self {
        case let .getUser(token: _, userId: id):
            if let id = id {
                return "users/\(id)"
            } else {
                return "user"
            }
        case .editUser:
            return "user"
        case let .getTeammates(token: _, userId: id):
            return "users/\(id)/teammates"
        case let .rateUser(token: _, userId: id):
            return "users/\(id)/actions/rate"
        case let .unrateUser(token: _, userId: id):
            return "users/\(id)/actions/unrate"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUser:
            return .get
        case .editUser:
            return .put
        case .getTeammates:
            return .get
        case .rateUser:
            return .post
        case .unrateUser:
            return .post
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .getUser:
            return nil
        case let .editUser(token: _, image: image):
            return nil
        case .getTeammates:
            return nil
        case .rateUser:
            return nil
        case .unrateUser:
            return nil
        }
    }
    
    var headers: [String : Any]? {
        switch self {
        case .getUser(token: let token, userId: _):
            return ["Authorization": "Bearer \(token)"]
        case .editUser(token: let token, image: _):
            return ["Authorization": "Bearer \(token)"]
        case .getTeammates(token: let token, userId: _):
            return ["Authorization": "Bearer \(token)"]
        case .rateUser(token: let token, userId: _):
            return ["Authorization": "Bearer \(token)"]
        case .unrateUser(token: let token, userId: _):
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
