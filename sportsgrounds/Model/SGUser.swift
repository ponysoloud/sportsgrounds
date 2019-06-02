//
//  SGUser.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

class SGUser: Decodable, Equatable, Parsable {
    
    let id: Int
    
    let name: String
    let surname: String
    
    let birthdate: Date
    
    let rating: Int
    let rated: Bool
    
    let imageUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case surname
        case birthdate = "birthday"
        case rating
        case rated
        case imageUrl = "image_url"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        surname = try container.decode(String.self, forKey: .surname)
        birthdate = try container.decode(Date.self, forKey: .birthdate)
        rating = try container.decode(Int.self, forKey: .rating)
        rated = try container.decodeIfPresent(Bool.self, forKey: .rated) ?? false
        
        if let imageUrlString = try container.decodeIfPresent(String.self, forKey: .imageUrl) {
            imageUrl = URL(string: SportsgroundsEnvironment().host + imageUrlString)
        } else {
            imageUrl = nil
        }
    }
    
    static func == (lhs: SGUser, rhs: SGUser) -> Bool {
        return lhs.id == rhs.id
    }
}
