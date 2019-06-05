//
//  UIViewController+Extensions.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addGestureRecognizerForHidingKeyboardOnTap() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //gestureRecognizer.cancelsTouchesInView = false
        
        view.addGestureRecognizer(gestureRecognizer)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {

    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
    }
}

extension UIViewController {
    
    func addBackButtonIfNeeded() {
        if let index = self.navigationController?.viewControllers.lastIndex(of: self), index > 0 {
            let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navigationBar.icon.back"), style: .plain, target: self, action: #selector(backButtonTap(_:)))
            backBarButtonItem.tintColor = UIColor.appBlack
            backBarButtonItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
            navigationItem.leftBarButtonItem = backBarButtonItem
        }
    }
    
    @objc private func backButtonTap(_ sender: UIBarButtonItem) {
        self.dismissKeyboard()
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
    func addExitButtonIfNeeded() {
        if self.isModal {
            let exitBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navigationBar.icon.exit"), style: .plain, target: self, action: #selector(exitButtonTap(_:)))
            exitBarButtonItem.tintColor = UIColor.appBlack
            exitBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            navigationItem.rightBarButtonItem = exitBarButtonItem
        }
    }
    
    @objc private func exitButtonTap(_ sender: UIBarButtonItem) {
        self.dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
}
