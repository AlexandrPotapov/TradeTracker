//
//  Router.swift
//  TradeTracker
//
//  Created by Alexander on 26.10.2024.
//

import UIKit

protocol RouterMainProtocol {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMainProtocol {
    func initionalViewController()
    func showTransactionsInfo(product: Product?)
    func popToRoot()
    func showAlert(title: String, message: String)
}


class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController? = nil, assemblyBuilder: AssemblyBuilderProtocol? = nil) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initionalViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createProductScene(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func showTransactionsInfo(product: Product?) {
        if let navigationController = navigationController {
            guard let detailViewController = assemblyBuilder?.createTransactionsInfo(product: product, router: self) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func showAlert(title: String, message: String) {
        if let navigationController = navigationController {
            guard let alertController = assemblyBuilder?.createAlert(title: title, message: message) else { return }
            navigationController.topViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
}
