//
//  SGViewController.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 17/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGViewController: SGFlowViewController {
    
    var preferredNavigationBarItemsConfigurationType: UINavigationController.ItemsConfigurationType {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setPreferredItemsConfiguration(preferredNavigationBarItemsConfigurationType)
    }
}
