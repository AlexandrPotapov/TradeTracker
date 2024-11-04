//
//  RouterProducts.swift
//  TradeTracker
//
//  Created by Alexander on 02.11.2024.
//

import UIKit

protocol RouterProductsProtocol{
    func showTransactionsInfo(product: ProductViewModel)
    func setRootViewController(root: UIViewController)
    func showAlert(title: String, message: String)
}

final class RouterProducts: RouterProductsProtocol {
    
    private weak var root: UIViewController?
    
    private let transactionsInfoBuilder: TransactionInfoBuilderProtocol
    private let alertBuilder: AlertBuilderProtocol
    
    init(transactionsInfoBuilder: TransactionInfoBuilderProtocol, alertBuilder: AlertBuilderProtocol) {
        self.transactionsInfoBuilder = transactionsInfoBuilder
        self.alertBuilder = alertBuilder
    }
    
    func showTransactionsInfo(product: ProductViewModel) {
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
