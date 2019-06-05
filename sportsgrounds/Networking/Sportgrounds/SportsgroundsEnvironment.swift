//
//  SportsgroundsEnvironment.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SportsgroundsEnvironment: Environment {

    var host: String {
        return "https://sportsgrounds-api.herokuapp.com"
    }

    var parameters: RequestParams? {
        return nil
    }

    var headers: [String : Any] {
        return [
            "Content-Type": "application/json"
        ]
    }
}
