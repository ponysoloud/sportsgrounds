//
//  UserRequest.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

enum UserRequest: Request {
    
    case getUser(token: String, userId: Int?)
    case editUser(token: String, imageName: String, imageData: Data)
    case getTeammates(token: String, userId: Int, count: Int?)

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
        case let .getTeammates(token: _, userId: id, count: _):
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
        case let .editUser(token: _, imageName: name, imageData: image):
            let imageString = image.base64EncodedString(options: .lineLength64Characters)
            
            let dict = [
                "imageName": name,
                "image": imageString
            ]
            
            return RequestParams.body(dict)
        case let .getTeammates(token: _, userId: _, count: count):
            let dict = [
                "count": String(count)
            ]
            return RequestParams.url(dict.unwrapped())
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
        case .editUser(token: let token, imageName: _, imageData: _):
            return ["Authorization": "Bearer \(token)"]
        case .getTeammates(token: let token, userId: _, count: _):
            return ["Authorization": "Bearer \(token)"]
        case .rateUser(token: let token, userId: _):
            return ["Authorization": "Bearer \(token)"]
        case .unrateUser(token: let token, userId: _):
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
