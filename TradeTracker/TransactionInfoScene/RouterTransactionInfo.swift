//
//  RouterTransactionInfo.swift
//  TradeTracker
//
//  Created by Alexander on 02.11.2024.
//

import UIKit

protocol RouterTransactionInfoProtocol{
    func setRootViewController(root: UIViewController)
    func showAlert(title: String, message: String)
}


final class RouterTransactionInfo: RouterTransactionInfoProtocol {
    
    var alertBuilder: AlertBuilderProtocol
    private weak var root: UIViewController?
    
    init(alertBuilder: AlertBuilderProtocol) {
        self.alertBuilder = alertBuilder
    }
    
    func setRootViewController(root: UIViewController) {
        self.root = root
    }
    
    func showAlert(title: String, message: String) {
        let alertController = alertBuilder.buildAlert(title: title, message: message)
        root?.navigationController?.topViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
