//
//  RouterProducts.swift
//  TradeTracker
//
//  Created by Alexander on 02.11.2024.
//

import UIKit
import Swinject

//final class RouterProducts: RouterProductsProtocol {
//    
//    private weak var root: UIViewController?
//    
//    private let transactionsInfoBuilder: TransactionInfoBuilderProtocol
//    private let alertBuilder: AlertBuilderProtocol
//    
//    init(transactionsInfoBuilder: TransactionInfoBuilderProtocol, alertBuilder: AlertBuilderProtocol) {
//        self.transactionsInfoBuilder = transactionsInfoBuilder
//        self.alertBuilder = alertBuilder
//    }
//    
//    func showTransactionsInfo(with sku: String) {
//        let viewController = transactionsInfoBuilder.buildTransactionsInfo(with: sku)
//        root?.navigationController?.pushViewController(viewController, animated: true)
//    }
//    
//    func showAlert(title: String, message: String) {
//        let alertController = alertBuilder.buildAlert(title: title, message: message)
//        root?.navigationController?.topViewController?.present(alertController, animated: true, completion: nil)
//    }
//    
//    func setRootViewController(root: UIViewController) {
//        self.root = root
//    }
//}

final class RouterProducts: RouterProductsProtocol {
    
    private weak var root: UIViewController?
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func showTransactionsInfo(with sku: String) {
        guard let transactionsInfoScene = container.resolve(UIViewController.self, name: "transactionsInfoScene", argument: sku) else {
            fatalError("Failed to resolve TransactionsInfoViewController")
        }
        root?.navigationController?.pushViewController(transactionsInfoScene, animated: true)
        print(root ?? "nil")
    }
    
    func showAlert(title: String, message: String) {
        guard let alertController = container.resolve(UIViewController.self, name: "alertVC", arguments: title, message) else {
            fatalError("Failed to resolve UIViewController as alert")
        }
        root?.navigationController?.topViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func setRootViewController(root: UIViewController) {
        self.root = root
    }
}
