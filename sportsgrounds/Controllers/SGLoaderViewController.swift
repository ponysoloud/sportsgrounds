//
//  SGLoaderViewController.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGLoaderViewController: SGFlowViewController {
    
    private lazy var loadingLayer: SGSpinningAnimationLayer = {
        let layer = SGSpinningAnimationLayer(frame: CGRect(x: (self.view.width - 120) / 2,
                                                           y: (self.view.height - 120) / 2,
                                                           width: 120,
                                                           height: 120),
                                             color: .appWhite,
                                             lineWidth: 8.0)

        self.view.layer.addSublayer(layer)
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.appBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingLayer.animate()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        loadingLayer.removeAllAnimations()
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let navigationController = self.navigationController {
            let navigationStack = navigationController.viewControllers.filter { $0 != self }
            navigationController.setViewControllers(navigationStack, animated: false)
        }
    }
}
