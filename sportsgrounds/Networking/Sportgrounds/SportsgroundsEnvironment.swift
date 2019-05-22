//
//  SportsgroundsEnvironment.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct SportsgroundsEnvironment: Environment {

    var host: String {
        return "http://127.0.0.1:5000"
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
