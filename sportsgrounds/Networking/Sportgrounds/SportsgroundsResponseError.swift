//
//  SportsgroundsResponseError.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum SportsgroundsResponseError: Error, Equatable {
    case serverFailureResponse(message: String)
    case undefinedServerFailureResponse
}
