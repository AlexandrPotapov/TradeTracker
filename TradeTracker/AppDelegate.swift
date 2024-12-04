//
//  AppDelegate.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let container = Container()
        _ = Assembler([AlertAssembly(), SharedDataManagerAssembly(), ProductsAssembly(), TransactionsInfoAssembly()], container: container)
        
        guard let productsScene = container.resolve(UIViewController.self, name: "productsScene") else {
            fatalError("ProductsScene не зарегистрирован")
        }
        
        let navigationController = UINavigationController(rootViewController: productsScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

}
