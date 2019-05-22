//
//  GroundAPI.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 15/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation
import CoreLocation
import PromiseKit

struct GroundAPI: NetworkService {
    
    private let provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
    
    func getGrounds(withToken token: String, userLocation: CLLocation? = nil) -> Promise<SGGroundsPaginationResponse> {
        return Promise { seal in
            let request = GroundRequest.getGrounds(token: token,
                                                   latitude: userLocation?.coordinate.latitude,
                                                   longitude: userLocation?.coordinate.longitude)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    
                    let success: (SGGroundsPaginationResponse) -> Void = { s in
                        seal.fulfill(s)
                    }
                    
                    let failure: (SGBasicResponse) -> Void = { f in
                        let error = SportsgroundsResponseError.serverFailureResponse(message: f.message)
                        seal.reject(error)
                    }
                    
                    do {
                        try response.extractResult(success: success, failure: failure)
                    } catch let error {
                        seal.reject(error)
                    }
                case .error(let error):
                    seal.reject(error)
                }
                }.catch {
                    error in
                    seal.reject(error)
            }
        }
    }
    
    func getGroundsLoocations(withToken token: String, northEastCoordinate: CLLocationCoordinate2D, southWestCoordinate: CLLocationCoordinate2D) -> Promise<[SGGroundLocation]> {
        return Promise { seal in
            let request = GroundRequest.getGroundsGeography(token: token,
                                                            northEastLatitude: northEastCoordinate.latitude,
                                                            northEastLongitude: northEastCoordinate.longitude,
                                                            southWestLatitude: southWestCoordinate.latitude,
                                                            southWestLongitude: southWestCoordinate.longitude)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    
                    let success: (SGGroundsResponse) -> Void = { s in
                        seal.fulfill(s.grounds)
                    }
                    
                    let failure: (SGBasicResponse) -> Void = { f in
                        let error = SportsgroundsResponseError.serverFailureResponse(message: f.message)
                        seal.reject(error)
                    }
                    
                    do {
                        try response.extractResult(success: success, failure: failure)
                    } catch let error {
                        seal.reject(error)
                    }
                case .error(let error):
                    seal.reject(error)
                }
                }.catch {
                    error in
                    seal.reject(error)
            }
        }
    }
    
    func getGroundDetails(withToken token: String, groundId: Int) -> Promise<SGGround> {
        return Promise { seal in
            let request = GroundRequest.getGround(token: token, groundId: groundId)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    
                    let success: (SGGroundResponse) -> Void = { s in
                        seal.fulfill(s.ground)
                    }
                    
                    let failure: (SGBasicResponse) -> Void = { f in
                        let error = SportsgroundsResponseError.serverFailureResponse(message: f.message)
                        seal.reject(error)
                    }
                    
                    do {
                        try response.extractResult(success: success, failure: failure)
                    } catch let error {
                        seal.reject(error)
                    }
                case .error(let error):
                    seal.reject(error)
                }
                }.catch {
                    error in
                    seal.reject(error)
            }
        }
    }
    
    func cancelAllTasks() {
        self.provider.cancelAllTasks()
    }
}
