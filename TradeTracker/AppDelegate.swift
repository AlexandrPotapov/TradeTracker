//
//  AppDelegate.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataManager: DataManager!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Создаем общий экземпляр DataManager с dataLoader
        let dataLoader = PlistDataLoader()
        dataManager = DataManager(dataLoader: dataLoader)
        
        let navigationController = UINavigationController()
        let assemblyBuilder = AssemblyModuleBuilder(dataManager: dataManager)
        let router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
        router.initionalViewController()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

}

