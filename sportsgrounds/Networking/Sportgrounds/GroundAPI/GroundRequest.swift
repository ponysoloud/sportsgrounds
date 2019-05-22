//
//  GroundRequest.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 15/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

enum GroundRequest: Request {
    
    case getGrounds(token: String, latitude: Double?, longitude: Double?)
    case getGroundsGeography(token: String, northEastLatitude: Double, northEastLongitude: Double, southWestLatitude: Double, southWestLongitude: Double)
    
    case getGround(token: String, groundId: Int)
    
    var path: String {
        switch self {
        case .getGrounds:
            return "grounds"
        case .getGroundsGeography:
            return "grounds/geo"
        case let .getGround(token: _, groundId: id):
            return "grounds/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getGrounds:
            return .get
        case .getGroundsGeography:
            return .post
        case .getGround:
            return .get
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case let .getGrounds(token: _, latitude: latitude, longitude: longitude):
            let dict = [
                "latitude": String(latitude),
                "longitude": String(longitude)
            ]
            return RequestParams.url(dict.unwrapped())
        case let .getGroundsGeography(token: _,
                                      northEastLatitude: northEastLatitude,
                                      northEastLongitude: northEastLongitude,
                                      southWestLatitude: southWestLatitude,
                                      southWestLongitude: southWestLongitude):
            let dict = [
                "geobounds": [
                    "northEast": [
                        "latitude": northEastLatitude,
                        "longitude": northEastLongitude
                    ],
                    "southWest": [
                        "latitude": southWestLatitude,
                        "longitude": southWestLongitude
                    ]
                ]
            ]
            return RequestParams.body(dict)
        case .getGround:
            return nil
        }
    }
    
    var headers: [String : Any]? {
        switch self {
        case .getGrounds(token: let token, latitude: _, longitude: _):
            return ["Authorization": "Bearer \(token)"]
        case .getGroundsGeography(token: let token,
                                  northEastLatitude: _,
                                  northEastLongitude: _,
                                  southWestLatitude: _,
                                  southWestLongitude: _):
            return ["Authorization": "Bearer \(token)"]
        case .getGround(token: let token, groundId: _):
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
