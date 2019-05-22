//
//  UINavigationController+Extensions.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    static var application: UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = true
        navigationController.view.backgroundColor = .clear
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        
        return navigationController
    }
    
    static var main: UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = UIColor.appWhite
        navigationController.navigationBar.backgroundColor = UIColor.appWhite
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.titleTextAttributes = [.font: UIFont.title2Font,
                                                                  .foregroundColor: UIColor.appBlack]
        
        return navigationController
    }
    
    static func main(withRootViewController rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController.main
        navigationController.pushViewController(rootViewController, animated: false)
        
        return navigationController
    }
}

extension UINavigationController {
    
    func pushFromRoot(viewController: UIViewController, animated: Bool) {
        self.pushViewController(viewController, animated: animated)
        
        let newHierarchy = [viewController]
        self.setViewControllers(newHierarchy, animated: false)
    }
}

extension UINavigationController {
    
    enum ItemsConfigurationType {
        case standalone
        case `default`
        case modal
    }
    
    func setPreferredItemsConfiguration(_ itemsConfiguration: UINavigationController.ItemsConfigurationType) {
        guard let viewController = self.viewControllers.last else {
            return
        }
        
        switch itemsConfiguration {
        case .standalone:
            viewController.navigationItem.hidesBackButton = true
            viewController.navigationItem.leftBarButtonItem = nil
            viewController.navigationItem.rightBarButtonItem = nil
        case .default:
            viewController.addBackButtonIfNeeded()
            viewController.navigationItem.rightBarButtonItem = nil
        case .modal:
            viewController.addBackButtonIfNeeded()
            viewController.addExitButtonIfNeeded()
        }
    }
}
