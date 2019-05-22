//
//  SGEventDataSourceProvider.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGEventDataSourceProvider {
    
    let userId: Int
    
    var event: SGEvent?
    
    private var dataSource: [SGDataSourceProviderSection] = []
    
    init(userId: Int) {
        self.userId = userId
    }
    
    func update(withEvent event: SGEvent) {
        self.event = event
        self.updateDataSource()
    }
    
    private func updateDataSource() {
        guard let event = self.event else {
            return self.dataSource = []
        }
        
        // General Info Section
        let generalInfoHeader = SGDataSourceProviderHeaderItem.title(event.title.capitalizingFirst)
        var generalInfoItems: [SGDataSourceProviderRowItem] = []
        
        if !event.description.isEmpty {
            generalInfoItems.append(.description(event.description))
        }
        generalInfoItems.append(.eventDetails(event))
        
        let generalInfoSection = SGDataSourceProviderSection(headerItem: generalInfoHeader,
                                                             rowItems: generalInfoItems)
        
        // Ground Section
        let groundHeader = SGDataSourceProviderHeaderItem.title("Площадка")
        let groundItems: [SGDataSourceProviderRowItem] = [.ground(event.ground)]
        
        let groundSection = SGDataSourceProviderSection(headerItem: groundHeader,
                                                        rowItems: groundItems)
        
        // Participants Section
        let participantsHeader = SGDataSourceProviderHeaderItem.title("Участники")
        var participantsItems: [SGDataSourceProviderRowItem] = []
        
        var teams: [SGTeam] = []
        
        switch event.type {
        case .training:
            if let training = event.training {
                teams = [training.team]
            }
        case .match:
            if let match = event.match {
                teams = [match.teamA, match.teamB]
            }
        case .tourney:
            if let tourney = event.tourney {
                teams = tourney.teams
            }
        }
        
        let userParticipated = event.participated ?? false
        
        for (index, team) in teams.enumerated() {
            if teams.count > 1 {
                participantsItems.append(.team(team, index + 1))
            } else {
                participantsItems.append(.team(team, nil))
            }
            
            if team.participants.count == 0 {
                participantsItems.append(.text("Здесь пока еще нет участников"))
            }
            
            for (index, participant) in team.participants.enumerated() {
                let isOwner: Bool = (participant.id == event.owner.id)
                let isYou: Bool = (participant.id == self.userId)
                
                participantsItems.append(.user(participant, isOwner: isOwner, isYou: isYou))
                
                if index < team.participants.count - 1 {
                    participantsItems.append(.separator)
                }
            }
            
            if !userParticipated {
                participantsItems.append(.button("Вступить", teamId: team.id))
            }
        }
        
        let participantsSection = SGDataSourceProviderSection(headerItem: participantsHeader,
                                                              rowItems: participantsItems)
        
        self.dataSource = [generalInfoSection, groundSection, participantsSection]
    }
}

extension SGEventDataSourceProvider: SGDataSourceProvider {
    
    var numberOfSections: Int {
        return self.dataSource.count
    }
    
    func rowItems(forSection section: Int) -> [SGDataSourceProviderRowItem] {
        guard 0..<self.dataSource.count ~= section else {
            return []
        }
        return self.dataSource[section].rowItems
    }
    
    func rowItem(forIndexPath indexPath: IndexPath) -> SGDataSourceProviderRowItem? {
        let items = self.rowItems(forSection: indexPath.section)
        
        guard 0..<items.count ~= indexPath.row else {
            return nil
        }
        return items[indexPath.row]
    }
    
    func headerItem(forSection section: Int) -> SGDataSourceProviderHeaderItem? {
        guard 0..<self.dataSource.count ~= section else {
            return nil
        }
        return self.dataSource[section].headerItem
    }
}
