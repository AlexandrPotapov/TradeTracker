//
//  RouterTransactionInfo.swift
//  TradeTracker
//
//  Created by Alexander on 02.11.2024.
//

import UIKit

protocol RouterTransactionInfoProtocol{
    func showAlert(title: String, message: String)
}

final class RouterTransactionInfo: RouterTransactionInfoProtocol {
    private let alertQueueManager: AlertQueueManagerProtocol
    private let alertDisplayManager: AlertDisplayManagerProtocol
    private let alertBuilder: AlertBuilderProtocol
    
    init(alertQueueManager: AlertQueueManagerProtocol, alertDisplayManager: AlertDisplayManagerProtocol, alertBuilder: AlertBuilderProtocol) {
        self.alertQueueManager = alertQueueManager
        self.alertDisplayManager = alertDisplayManager
        self.alertBuilder = alertBuilder
    }

    func showAlert(title: String, message: String) {
        let alertController = alertBuilder.buildAlert(title: title, message: message)
        alertQueueManager.enqueueAlert(alertController)
        alertDisplayManager.showNextAlertIfPresent()
    }
}
