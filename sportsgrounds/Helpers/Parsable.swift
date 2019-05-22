//
//  SGParsable.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 22/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

protocol Parsable {
    
    init(from dict: [String: Any]) throws
}

extension Parsable where Self: Decodable {
    
    init(from dict: [String: Any]) throws {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
        self = try decoder.decode(Self.self, from: jsonData)
    }
}
