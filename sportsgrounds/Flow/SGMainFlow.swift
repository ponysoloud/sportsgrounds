//
//  SGMainFlow.swift
//  wallet
//
//  Created by  me on 02/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

final class SGMainFlow: SGScreenFlow {

    private let user: SGApplicationUser
    private let socketsProvider: SocketsProvider
    private unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, user: SGApplicationUser, socketsProvider: SocketsProvider) {
        self.navigationController = navigationController
        self.user = user
        self.socketsProvider = socketsProvider
    }
    
    func begin() {
        self.navigationController.pushFromRoot(viewController: mainContainer, animated: true)
    }
    
    private var mainContainer: UITabBarController {
        let tabBarController = UITabBarController()
        
        // Create TabBar Items
        let groundsTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabBar.item.icon.map"), tag: 0)
        groundsTabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        
        let eventsTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabBar.item.icon.list"), tag: 1)
        eventsTabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        
        let profileTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabBar.item.icon.profile"), tag: 2)
        profileTabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        
        // Instantiate TabBar child viewControllers
        
        let groundsViewController = UINavigationController.main(withRootViewController: groundsScreen)
        groundsViewController.tabBarItem = groundsTabBarItem
        
        let eventsViewController = UINavigationController.main(withRootViewController: eventsScreen)
        eventsViewController.tabBarItem = eventsTabBarItem
        
        let profileViewController = UINavigationController.main(withRootViewController: profileScreen)
        profileViewController.tabBarItem = profileTabBarItem
        
        tabBarController.setViewControllers([groundsViewController, eventsViewController, profileViewController], animated: false)
        
        tabBarController.tabBar.tintColor = UIColor.appBlack
        tabBarController.tabBar.backgroundColor = UIColor.appWhite
        
        tabBarController.selectedIndex = 0
        return tabBarController
    }
    
    private var groundsScreen: SGGroundsViewController {
        let vc = SGGroundsViewController(user: user)
        vc.accessibilityViewIsModal = true
        
        let onGround: (Int) -> Void = {
            [unowned self, unowned vc] groundId in

            let target = self.groundScreen
            target.groundId = groundId
            let navigationController = UINavigationController.main(withRootViewController: target)
            vc.present(navigationController, animated: true, completion: nil)
        }
        
        vc.onGround = onGround
        vc.groundAPI = GroundAPI(provider: Provider(environment: SportsgroundsEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }
    
    private var groundScreen: SGGroundViewController {
        let vc = SGGroundViewController(user: user)
        vc.modalPresentationStyle = .overCurrentContext
        
        let onEvent: (Int) -> Void = {
            [unowned self, unowned vc] eventId in
            
            let target = self.eventScreen
            target.eventId = eventId
            vc.navigationController?.pushViewController(target, animated: true)
        }
        
        let onAddEvent: (SGGround) -> Void = {
            [unowned self, unowned vc] ground in
            
            let processController = SGCreatingEventProcess(ground: ground)
            let target = self.createEventScreen(withStep: processController.step)
            target.processController = processController
            vc.navigationController?.pushViewController(target, animated: true)
        }
        
        vc.onEvent = onEvent
        vc.onAddEvent = onAddEvent
        vc.eventAPI = EventAPI(provider: Provider(environment: SportsgroundsEnvironment(), dispatcher: HTTPDispatcher()))
        vc.groundAPI = GroundAPI(provider: Provider(environment: SportsgroundsEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }
    
    private func createEventScreen(withStep step: SGCreatingEventStep) -> SGCreateEventViewController {
        let vc = SGCreateEventViewController(user: user, step: step)
        
        let onContinue: (SGCreatingEventProcess) -> Void = {
            [unowned self, unowned vc] processController in
            
            if processController.isCompleted {
                vc.createEvent()
            } else {
                let target = self.createEventScreen(withStep: processController.step)
                target.processController = processController
                vc.navigationController?.pushViewController(target, animated: true)
            }
        }
        
        let onCreate: () -> Void = {
            [unowned vc] in
            guard let viewControllers = vc.navigationController?.viewControllers else {
                return
            }
            let newViewControllers = viewControllers.filter { !($0 is SGCreateEventViewController) }
            vc.navigationController?.setViewControllers(newViewControllers, animated: true)
        }
        
        vc.onCreate = onCreate
        vc.onContinue = onContinue
        vc.eventAPI = EventAPI(provider: Provider(environment: SportsgroundsEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }
    
    private var eventScreen: SGEventViewController {
        let vc = SGEventViewController(user: user)
        vc.modalPresentationStyle = .overCurrentContext
        
        let onGround: (Int) -> Void = {
            [unowned self, unowned vc] groundId in
            
            if let groundViewController = vc.navigationController?.viewControllers.last(where: {
                $0 is SGGroundViewController
            }) as? SGGroundViewController {
                groundViewController.groundId = groundId
                vc.navigationController?.popToViewController(groundViewController, animated: true)
            } else {
                let target = self.groundScreen
                target.groundId = groundId
                vc.navigationController?.pushViewController(target, animated: true)
            }
        }
        
        let onChat: (Int) -> Void = {
            [unowned self, unowned vc] eventId in
            
            let target = self.eventChatScreen
            target.eventId = eventId
            vc.navigationController?.pushViewController(target, animated: true)
        }
        
        let onMap: (SGCoordinate) -> Void = {
            [unowned self, unowned vc] coordinates in
            
            let tabBarController = self.navigationController.viewControllers.first as? UITabBarController
            tabBarController?.selectedIndex = 0
            vc.dismiss(animated: true, completion: {
                if let groundsNavigationController = tabBarController?.viewControllers?.first as? UINavigationController,
                    let groundsViewController = groundsNavigationController.viewControllers.first as? SGGroundsViewController {
                    groundsViewController.showGrounds(inLocation: coordinates)
                }
            })
        }
        
        vc.onChat = onChat
        vc.onGround = onGround
        vc.onMap = onMap
        vc.eventAPI = EventAPI(provider: Provider(environment: SportsgroundsEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }
    
    private var eventChatScreen: SGEventChatViewController {
        let vc = SGEventChatViewController(user: user)
        
        vc.socketsProvider = self.socketsProvider
        vc.eventAPI = EventAPI(provider: Provider(environment: SportsgroundsEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }
    
    private var eventsScreen: SGEventsViewController {
        let vc = SGEventsViewController(user: user)
        
        let onEvent: (Int) -> Void = {
            [unowned self, unowned vc] eventId in
            
            let target = self.eventScreen
            target.eventId = eventId
            let navigationController = UINavigationController.main(withRootViewController: target)
            vc.present(navigationController, animated: true, completion: nil)
        }
        
        vc.onEvent = onEvent
        vc.eventAPI = EventAPI(provider: Provider(environment: SportsgroundsEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }
    
    private var profileScreen: SGProfileViewController {
        let vc = SGProfileViewController()

        vc.flow = self
        return vc
    }
}
