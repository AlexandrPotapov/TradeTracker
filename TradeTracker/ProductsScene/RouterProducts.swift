//
//  RouterProducts.swift
//  TradeTracker
//
//  Created by Alexander on 02.11.2024.
//

import UIKit

protocol RouterProductsProtocol{
    func showTransactionsInfo(with sku: String)
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
    
    func showTransactionsInfo(with sku: String) {
        let viewController = transactionsInfoBuilder.buildTransactionsInfo(with: sku)
        root?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = alertBuilder.buildAlert(title: title, message: message)
        root?.navigationController?.topViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func setRootViewController(root: UIViewController) {
        self.root = root
    }
}
