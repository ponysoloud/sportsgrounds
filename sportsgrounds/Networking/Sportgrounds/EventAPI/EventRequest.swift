//
//  EventRequest.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum EventRequest: Request {
    
    case getEvents(token: String, page: Int?, groundId: Int?, status: Int?, type: Int?, activity: Int?, ownerId: Int?, participantId: Int?)
    case createEvent(token: String, type: Int, title: String, description: String, activity: Int, participantsLevel: Int, participantsAgeFrom: Int, participantsAgeTo: Int, beginAt: String, endAt: String, groundId: Int, participantsCount: Int?, teamsCount: Int?, teamsSize: Int?)
    case getEvent(token: String, eventId: Int)
    case updateEvent(token: String, eventId: Int, title: String?, description: String?, teamsCount: Int?)
    case deleteEvent(token: String, eventId: Int)
    
    case joinToEvent(token: String, eventId: Int, teamId: Int)
    case leaveFromEvent(token: String, eventId: Int)
    
    case getEventMessages(token: String, skip: Int, count: Int?, eventId: Int)
    case sendEventMessage(token: String, eventId: Int, text: String)

    var path: String {
        switch self {
        case .getEvents, .createEvent:
            return "events"
        case .getEvent(token: _, eventId: let id),
             .updateEvent(token: _, eventId: let id, title: _, description: _, teamsCount: _),
             .deleteEvent(token: _, eventId: let id):
            return "events/\(id)"
        case .joinToEvent(token: _, eventId: let id, teamId: _):
            return "events/\(id)/actions/join"
        case .leaveFromEvent(token: _, eventId: let id):
            return "events/\(id)/actions/leave"
        case .getEventMessages(token: _, skip: _, count: _, eventId: let id),
             .sendEventMessage(token: _, eventId: let id, text: _):
            return "events/\(id)/messages"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getEvents:
            return .get
        case .createEvent:
            return .post
        case .getEvent:
            return .get
        case .updateEvent:
            return .put
        case .deleteEvent:
            return .delete
        case .joinToEvent:
            return .post
        case .leaveFromEvent:
            return .post
        case .getEventMessages:
            return .get
        case .sendEventMessage:
            return .post
        }
    }

    var parameters: RequestParams? {
        switch self {
        case let .getEvents(token: _, page: page, groundId: groundId, status: status, type: type, activity: activity, ownerId: ownerId, participantId: participantId):
            let dict = [
                "page": String(page),
                "groundId": String(groundId),
                "status": String(status),
                "type": String(type),
                "activity": String(activity),
                "ownerId": String(ownerId),
                "participantId": String(participantId)
            ]
            return RequestParams.url(dict.unwrapped())
        case let .createEvent(token: _, type: type, title: title, description: description, activity: activity, participantsLevel: participantsLevel, participantsAgeFrom: participantsAgeFrom, participantsAgeTo: participantsAgeTo, beginAt: beginAt, endAt: endAt, groundId: groundId, participantsCount: participantsCount, teamsCount: teamsCount, teamsSize: teamsSize):
            var eventDict: [String : Any] = [
                "title": title,
                "description": description,
                "activity": activity,
                "participantsLevel": participantsLevel,
                "participantsAgeFrom": participantsAgeFrom,
                "participantsAgeTo": participantsAgeTo,
                "beginAt": beginAt,
                "endAt": endAt,
                "groundId": groundId,
                ]
            
            if let participantsCount = participantsCount {
                eventDict["participantsCount"] = participantsCount
            }
            
            if let teamsCount = teamsCount {
                eventDict["teamsCount"] = teamsCount
            }
            
            if let teamsSize = teamsSize {
                eventDict["teamsSize"] = teamsSize
            }
            
            let dict: [String : Any] = [
                "eventType": type,
                "event": eventDict
                ]
            return RequestParams.body(dict)
        case .getEvent:
            return nil
        case let .updateEvent(token: _, eventId: _, title: title, description: description, teamsCount: teamsCount):
            var dict: [String: Any] = [:]
            
            if let title = title {
                dict["title"] = title
            }
            
            if let description = description {
                dict["description"] = description
            }
            
            if let teamsCount = teamsCount {
                dict["teamsCount"] = teamsCount
            }
            return RequestParams.body(dict)
        case .deleteEvent:
            return nil
        case let .joinToEvent(token: _, eventId: _, teamId: teamId):
            let dict = [
                "teamId": String(teamId)
            ]
            return RequestParams.url(dict)
        case .leaveFromEvent:
            return nil
        case let .getEventMessages(token: _, skip: skip, count: count, eventId: _):
            let dict = [
                "skip": String(skip),
                "count": String(count)
            ]
            return RequestParams.url(dict.unwrapped())
        case let .sendEventMessage(token: _, eventId: _, text: text):
            let dict = [
                "text": text
            ]
            return RequestParams.body(dict)
        }
    }

    var headers: [String : Any]? {
        switch self {
        case .getEvents(token: let token, page: _, groundId: _, status: _, type: _, activity: _, ownerId: _, participantId: _):
            return ["Authorization": "Bearer \(token)"]
        case .createEvent(token: let token, type: _, title: _, description: _, activity: _, participantsLevel: _, participantsAgeFrom: _, participantsAgeTo: _, beginAt: _, endAt: _, groundId: _, participantsCount: _, teamsCount: _, teamsSize: _):
            return ["Authorization": "Bearer \(token)"]
        case .getEvent(token: let token, eventId: _):
            return ["Authorization": "Bearer \(token)"]
        case .updateEvent(token: let token, eventId: _, title: _, description: _, teamsCount: _):
            return ["Authorization": "Bearer \(token)"]
        case .deleteEvent(token: let token, eventId: _):
            return ["Authorization": "Bearer \(token)"]
        case .joinToEvent(token: let token, eventId: _, teamId: _):
            return ["Authorization": "Bearer \(token)"]
        case .leaveFromEvent(token: let token, eventId: _):
            return ["Authorization": "Bearer \(token)"]
        case .getEventMessages(token: let token, skip: _, count: _, eventId: _):
            return ["Authorization": "Bearer \(token)"]
        case .sendEventMessage(token: let token, eventId: _, text: _):
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
