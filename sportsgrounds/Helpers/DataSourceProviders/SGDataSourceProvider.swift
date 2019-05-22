//
//  SGDataSourceProvider.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 17/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

enum SGDataSourceProviderRowItem {
    case ground(SGGround)
    case description(String)
    case eventDetails(SGEvent)
    case team(SGTeam, Int?)
    case text(String)
    case user(SGUser, isOwner: Bool, isYou: Bool)
    case button(String, teamId: Int)
    case separator
}

enum SGDataSourceProviderHeaderItem {
    case title(String)
}

protocol SGDataSourceProvider {
    
    var numberOfSections: Int { get }
    
    func rowItems(forSection section: Int) -> [SGDataSourceProviderRowItem]
    
    func rowItem(forIndexPath indexPath: IndexPath) -> SGDataSourceProviderRowItem?
    
    func headerItem(forSection section: Int) -> SGDataSourceProviderHeaderItem?
}

class SGDataSourceProviderSection {
    let headerItem: SGDataSourceProviderHeaderItem?
    let rowItems: [SGDataSourceProviderRowItem]
    
    init(headerItem: SGDataSourceProviderHeaderItem?, rowItems: [SGDataSourceProviderRowItem]) {
        self.headerItem = headerItem
        self.rowItems = rowItems
    }
}
