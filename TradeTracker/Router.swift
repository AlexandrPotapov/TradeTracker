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
    
}
