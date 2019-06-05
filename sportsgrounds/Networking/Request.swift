//
//  Request.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

/**
 Protocol defines request with path, method, parameters and optional headers. Can be used implementing with enum object which cases are different requests uniting logically.
 */
protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: RequestParams? { get }
    var headers: [String: Any]? { get }
}

enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
}

enum RequestParams {
    case body([String: Any])
    case url([String: String])
}
