//
//  RouterProductsScene.swift
//  TradeTracker
//
//  Created by Alexander on 02.11.2024.
//

import UIKit

protocol RouterProductsSceneProtocol{
    func showTransactionsInfo(product: Product?)
    func setRootViewController(root: UIViewController)
    func showAlert(title: String, message: String)
}


final class RouterProducts: RouterProductsSceneProtocol {
    
    private weak var root: UIViewController?

    private let transactionsInfoBuilder: TransactionInfoBuilderProtocol
    private let alertBuilder: AlertBuilderProtocol

    
    init(transactionsInfoBuilder: TransactionInfoBuilderProtocol, alertBuilder: AlertBuilderProtocol) {
        self.transactionsInfoBuilder = transactionsInfoBuilder
        self.alertBuilder = alertBuilder
    }
    
    
    func showTransactionsInfo(product: Product?) {
        let viewController = transactionsInfoBuilder.buildTransactionsInfo(product: product)
        root?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setRootViewController(root: UIViewController) {
        self.root = root
    }

    func showAlert(title: String, message: String) {
        let alertController = alertBuilder.buildAlert(title: title, message: message)
        root?.navigationController?.topViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
