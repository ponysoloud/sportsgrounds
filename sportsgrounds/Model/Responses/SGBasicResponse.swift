//
//  SGBasicResponse.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 15/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGBasicResponse: Decodable, Parsable {
    
    let status: String
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
