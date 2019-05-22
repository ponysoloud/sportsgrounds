//
//  SGMessage.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 21/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGMessage: Decodable, Equatable, Parsable {
    
    let eventId: Int
    let sender: SGUser
    let text: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case eventId
        case sender
        case text
        case createdAt
    }
}
