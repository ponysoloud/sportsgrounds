//
//  Environment.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

/**
 Protocol defines general API object that provides host path and default headers.
 */
protocol Environment {

    var host: String { get }

    var parameters: RequestParams? { get }

    var headers: [String: Any] { get }
}
