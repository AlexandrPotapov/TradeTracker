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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        let productsScene = ProductsBuilder().buildProduct()
        let navigationController = UINavigationController(rootViewController: productsScene)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

}

