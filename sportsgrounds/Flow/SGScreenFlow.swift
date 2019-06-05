//
//  SGScreenFlow.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

/**
 Protocol defines basic interface for screens routing. It knows UIViewController classes of its flow's screens, so then it passes needed parameters between screens and uses NavigationController for routing between them.
 */
protocol SGScreenFlow {

    func begin()
}
