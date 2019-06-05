//
//  Dispatcher.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import PromiseKit

/**
 Protocol defines object, that should implement sending requests and handling responses on basic level.
 Use to organize work with network through URLSession, Alamofire or another Networks modules using one Dispatcher template.
 */
protocol Dispatcher {

    func dispatch(request: Request, with environment: Environment) -> Promise<Response>

    func cancelAllTasks()
}
