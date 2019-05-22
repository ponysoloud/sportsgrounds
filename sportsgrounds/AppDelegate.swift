//
//  AppDelegate.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 15/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit
import GoogleMaps
import PromiseKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private var mainScreenFlow: SGScreenFlow!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure Google Maps SDK
        GMSServices.provideAPIKey("AIzaSyCSqp033XAqi79xvH2OAezLzgZr2WeGfCs")
        
        // Setup beginning application state
        let localDataManager = SGLocalDataManager(keychainConfiguration: SGSportsgroundsKeychainConfiguration())
        
        let socketsProvider = SGSocketsProvider(environment: SGSocketsEnvironment())
        socketsProvider.connect(toSocket: SGSocket.eventMessages, withHandler: {
            socket in
            print("\(socket.namespace) was connected")
        })
        
        let navigationController = UINavigationController.application

        if let token = localDataManager.getToken() {

            let loader = SGLoaderViewController()
            navigationController.pushViewController(loader, animated: false)

            let authAPI = AuthAPI(provider: Provider(environment: SportsgroundsEnvironment(), dispatcher: HTTPDispatcher()))
            let userAPI = UserAPI(provider: Provider(environment: SportsgroundsEnvironment(), dispatcher: HTTPDispatcher()))
            
            firstly {
                authAPI.refresh(token: token)
            }.then {
                (token: String) -> Promise<(String, SGUser)> in
                
                localDataManager.save(token: token)
                return userAPI.getUser(withToken: token).map { (token, $0) }
            }.done {
                [unowned self]
                token, user in
                
                let user = SGApplicationUser.save(withToken: token, user: user)
                let screenFlow = SGMainFlow(navigationController: navigationController, user: user, socketsProvider: socketsProvider)
                
                self.mainScreenFlow = screenFlow
                self.mainScreenFlow.begin()
            }.catch {
                [unowned self]
                _ in

                let screenFlow = SGAuthorizationFlow(navigationController: navigationController, socketsProvider: socketsProvider)

                self.mainScreenFlow = screenFlow
                self.mainScreenFlow.begin()
            }
        } else {
            let screenFlow = SGAuthorizationFlow(navigationController: navigationController, socketsProvider: socketsProvider)

            self.mainScreenFlow = screenFlow
            self.mainScreenFlow.begin()
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        //        let provider = Provider(environment: SportgroundsEnvironment(), dispatcher: HTTPDispatcher())
        //        let api = AuthAPI(provider: provider)
        //
        //        print(Date().iso8601)
        //        api.register(email: "user5@example.ru", password: "password", name: "Alexander", surname: "Ponomarev", birthday: "1997-04-30T00:00:50+0000".iso8601!).done {
        //            [weak self]
        //            token in
        //
        //            print(token)
        //            }.catch {
        //                error in
        //
        //                print(error)
        //        }
        //
        //        api.login(email: "user3@example.ru", password: "password").done {
        //            [weak self]
        //            token in
        //
        //            print(token)
        //            }.catch {
        //                error in
        //
        //                print(error)
        //        }
        //
        //        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

