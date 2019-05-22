//
//  SGMessageResponse.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 21/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGMessageResponse: Decodable, Parsable {
    
    let status: String
    let newMessage: SGMessage
    
    private enum CodingKeys: String, CodingKey {
        case status
        case newMessage
    }
}
