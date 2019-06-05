//
//  UIRefreshControl+Extensions.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

extension UIRefreshControl {

    func beginRefreshing(in tableView: UITableView) {
        beginRefreshing()

        let offsetPoint = CGPoint.init(x: 0, y: -frame.size.height)
        tableView.setContentOffset(offsetPoint, animated: true)
    }
}
