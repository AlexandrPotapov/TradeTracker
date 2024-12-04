//
//  RouterTransactionInfo.swift
//  TradeTracker
//
//  Created by Alexander on 02.11.2024.
//

import UIKit
import Swinject

//protocol RouterTransactionInfoProtocol{
//    func showAlert(title: String, message: String)
//}
//
//final class RouterTransactionInfo: RouterTransactionInfoProtocol {
//    private let alertQueueManager: AlertQueueManagerProtocol
//    private let alertDisplayManager: AlertDisplayManagerProtocol
//    private let alertBuilder: AlertBuilderProtocol
//    
//    init(alertQueueManager: AlertQueueManagerProtocol, alertDisplayManager: AlertDisplayManagerProtocol, alertBuilder: AlertBuilderProtocol) {
//        self.alertQueueManager = alertQueueManager
//        self.alertDisplayManager = alertDisplayManager
//        self.alertBuilder = alertBuilder
//    }
//
//    func showAlert(title: String, message: String) {
//        let alertController = alertBuilder.buildAlert(title: title, message: message)
//        alertQueueManager.enqueueAlert(alertController)
//        alertDisplayManager.showNextAlertIfPresent()
//    }
//}
//

final class RouterTransactionInfo: RouterTransactionInfoProtocol {
    private let alertQueueManager: AlertQueueManagerProtocol
    private let alertDisplayManager: AlertDisplayManagerProtocol
    private let container: Container
    
    init(alertQueueManager: AlertQueueManagerProtocol, alertDisplayManager: AlertDisplayManagerProtocol, container: Container) {
        self.alertQueueManager = alertQueueManager
        self.alertDisplayManager = alertDisplayManager
        self.container = container
    }

    func showAlert(title: String, message: String) {
        guard let alertController = container.resolve(UIViewController.self, name: "alertVC", arguments: title, message) else {
            fatalError("Failed to resolve UIViewController as alert")
        }
        
        alertQueueManager.enqueueAlert(alertController)
        alertDisplayManager.showNextAlertIfPresent()
    }
}
