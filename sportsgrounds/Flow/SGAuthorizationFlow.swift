//
//  SGAuthorizationFlow.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

final class SGAuthorizationFlow: SGScreenFlow {

    private let socketsProvider: SocketsProvider
    unowned var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, socketsProvider: SocketsProvider) {
        self.navigationController = navigationController
        self.socketsProvider = socketsProvider
    }
    
    func begin() {
        self.navigationController.pushFromRoot(viewController: onboardingScreen, animated: true)
    }
    
    private var onboardingScreen: SGOnboardingViewController {
        let vc = SGOnboardingViewController()
        
        let onContinue: () -> Void = {
            [unowned self] in
            
            let target = self.authorizationScreen
            self.navigationController.pushViewController(target, animated: true)
        }
        
        vc.onContinue = onContinue
        vc.flow = self
        return vc
    }
    
    private var authorizationScreen: SGAuthorizationViewController {
        let vc = SGAuthorizationViewController()
        
        let onEnter: (SGApplicationUser) -> Void = {
            [unowned self] user in
            
            self.mainFlow(withUser: user).begin()
        }
        
        let onRegistration: (SGAuthorizationProcess) -> Void = {
            [unowned self]
            processController in
            
            let target = self.registrationScreen
            target.processController = processController
            self.navigationController.pushViewController(target, animated: true)
        }
        
        vc.onEnter = onEnter
        vc.onRegistration = onRegistration
        vc.processController = SGAuthorizationProcess()
        vc.localDataManager = SGLocalDataManager(keychainConfiguration: SGSportsgroundsKeychainConfiguration())
        vc.userAPI = UserAPI(provider: Provider(environment: SportsgroundsEnvironment(), dispatcher: HTTPDispatcher()))
        vc.authAPI = AuthAPI(provider: Provider(environment: SportsgroundsEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }
    
    private var registrationScreen: SGRegistrationViewController {
        let vc = SGRegistrationViewController()
        
        let onEnter: (SGApplicationUser) -> Void = {
            [unowned self] user in
            
            self.mainFlow(withUser: user).begin()
        }
        
        vc.onEnter = onEnter
        vc.localDataManager = SGLocalDataManager(keychainConfiguration: SGSportsgroundsKeychainConfiguration())
        vc.userAPI = UserAPI(provider: Provider(environment: SportsgroundsEnvironment(), dispatcher: HTTPDispatcher()))
        vc.authAPI = AuthAPI(provider: Provider(environment: SportsgroundsEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }
    
    private func mainFlow(withUser user: SGApplicationUser) -> SGMainFlow {
        return SGMainFlow(navigationController: navigationController, user: user, socketsProvider: socketsProvider)
    }
}
