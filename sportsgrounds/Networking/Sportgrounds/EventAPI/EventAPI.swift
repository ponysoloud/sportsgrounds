//
//  EventAPI.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation
import PromiseKit

struct EventAPI: NetworkService {

    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }
    
    func getEvents(withToken token: String,
                   page: Int? = nil,
                   groundId: Int? = nil,
                   status: SGEventStatus? = nil,
                   type: SGEventType? = nil,
                   activity: SGActivity? = nil,
                   ownerId: Int? = nil,
                   participantId: Int? = nil) -> Promise<SGEventsPaginationResponse> {
        return Promise { seal in
            let request = EventRequest.getEvents(token: token,
                                                 page: page,
                                                 groundId: groundId,
                                                 status: status?.rawValue,
                                                 type: type?.rawValue,
                                                 activity: activity?.rawValue,
                                                 ownerId: ownerId,
                                                 participantId: participantId)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGEventsPaginationResponse) -> Void = { s in
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
    
    func createEvent(withToken token: String,
                     groundId: Int,
                     type: SGEventType,
                     title: String,
                     description: String,
                     activity: SGActivity,
                     participantsLevel: SGParticipantsLevel,
                     participantsAgeFrom: Int,
                     participantsAgeTo: Int,
                     beginAt: Date,
                     endAt: Date,
                     participantsCount: Int?,
                     teamsCount: Int?,
                     teamsSize: Int?) -> Promise<SGEvent> {
        
        return Promise { seal in
            let request = EventRequest.createEvent(token: token,
                                                   type: type.rawValue,
                                                   title: title,
                                                   description: description,
                                                   activity: activity.rawValue,
                                                   participantsLevel: participantsLevel.rawValue,
                                                   participantsAgeFrom: participantsAgeFrom,
                                                   participantsAgeTo: participantsAgeTo,
                                                   beginAt: beginAt.iso8601,
                                                   endAt: endAt.iso8601,
                                                   groundId: groundId,
                                                   participantsCount: participantsCount,
                                                   teamsCount: teamsCount,
                                                   teamsSize: teamsSize)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGEventResponse) -> Void = { s in
                        seal.fulfill(s.event)
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
    
    func updateEvent(withToken token: String, eventId: Int, title: String?, description: String?) -> Promise<SGEvent> {
        return Promise { seal in
            let request = EventRequest.updateEvent(token: token,
                                                   eventId: eventId,
                                                   title: title,
                                                   description: description,
                                                   teamsCount: nil)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGEventResponse) -> Void = { s in
                        seal.fulfill(s.event)
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
    
    func getEvent(withToken token: String, eventId: Int) -> Promise<SGEvent> {
        return Promise { seal in
            let request = EventRequest.getEvent(token: token, eventId: eventId)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGEventResponse) -> Void = { s in
                        seal.fulfill(s.event)
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
    
    func joinToEvent(withToken token: String, eventId: Int, teamId: Int) -> Promise<SGEvent> {
        return Promise { seal in
            let request = EventRequest.joinToEvent(token: token, eventId: eventId, teamId: teamId)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGEventResponse) -> Void = { s in
                        seal.fulfill(s.event)
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
    
    func leaveFromEvent(withToken token: String, eventId: Int) -> Promise<SGEvent> {
        return Promise { seal in
            let request = EventRequest.leaveFromEvent(token: token, eventId: eventId)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGEventResponse) -> Void = { s in
                        seal.fulfill(s.event)
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
    
    func getEventMessages(withToken token: String, skip: Int, count: Int? = nil, eventId: Int) -> Promise<SGMessagesPaginationResponse> {
        return Promise { seal in
            let request = EventRequest.getEventMessages(token: token, skip: skip, count: count, eventId: eventId)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGMessagesPaginationResponse) -> Void = { s in
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
    
    func sendEventMessage(withToken token: String, eventId: Int, text: String) -> Promise<SGMessage> {
        return Promise { seal in
            let request = EventRequest.sendEventMessage(token: token, eventId: eventId, text: text)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGMessageResponse) -> Void = { s in
                        seal.fulfill(s.newMessage)
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
}
