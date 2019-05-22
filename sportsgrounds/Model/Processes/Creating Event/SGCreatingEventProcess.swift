//
//  SGCreatingEventProcess.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 17/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGCreatingEventProcess {
    
    let ground: SGGround
    
    var title: String?
    var description: String?
    
    var activity: SGActivity?
    var type: SGEventType?
    
    var teamsCount: Int?
    var participantsCount: Int?
    
    var participantsLevel: SGParticipantsLevel?
    var participantsAgeFrom: Int?
    var participantsAgeTo: Int?
    
    var date: Date?
    var duration: Int?
    
    init(ground: SGGround) {
        self.ground = ground
    }
    
    // MARK: - Public getters
    
    var step: SGCreatingEventStep {
        for step in SGCreatingEventStep.allCases {
            if !isCompleted(step: step) {
                return step
            }
        }
        return .dateDetails
    }
    
    var isCompleted: Bool {
        return isCompleted(step: .general) && isCompleted(step: .activityDetails)
            && isCompleted(step: .participantsDetails) && isCompleted(step: .dateDetails)
    }
    
    // MARK: - Public functions
    
    func isCompleted(step: SGCreatingEventStep) -> Bool {
        switch step {
        case .general:
            return title != nil && description != nil
        case .activityDetails:
            if let activity = activity, let type = type, let _ = participantsCount {
                return ground.activities.contains(activity)
                && activity.accessibleEventTypes.contains(type)
                && type == .tourney ? teamsCount != nil : true
            }
            
            return false
        case .participantsDetails:
            return participantsLevel != nil && participantsAgeFrom != nil && participantsAgeTo != nil
        case .dateDetails:
            return date != nil && duration != nil
        }
    }
}
