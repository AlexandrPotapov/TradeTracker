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

final class RouterTransactionInfo: RouterTransactionInfoProtocol, AlertWindowDelegate {

    
    private var alertQueue = Queue<UIViewController>()
    private var alertWindow: AlertPresenterProtocol?
    private let alertPresenterFactory: AlertPresenterFactoryProtocol
    private let alertBuilder: AlertBuilderProtocol
    
    init(alertBuilder: AlertBuilderProtocol, alertPresenterFactory: AlertPresenterFactoryProtocol) {
        self.alertBuilder = alertBuilder
        self.alertPresenterFactory = alertPresenterFactory
    }
    
    func showAlert(title: String, message: String) {
        let alertController = alertBuilder.buildAlert(title: title, message: message)
        enqueueAlertForPresentation(alertController)
    }
        
    // MARK: - Present
    
    private func enqueueAlertForPresentation(_ alertController: UIViewController) {
        alertQueue.enqueue(alertController)
        
        showNextAlertIfPresent()
    }
    
    private func showNextAlertIfPresent() {
        guard alertWindow == nil,
              let alertController = alertQueue.dequeue() else {
                return
        }

        // Используем фабрику для создания нового alertWindow
        var newAlertWindow = alertPresenterFactory.makeAlertPresenter()
        newAlertWindow.delegate = self
        newAlertWindow.presentAlert(alertController)
        
        self.alertWindow = newAlertWindow
    }
    
    // MARK: - AlertWindowDelegate
    
    func alertWindow(_ alertWindow: AlertPresenterProtocol, didDismissAlert alertController: UIViewController) {
        self.alertWindow = nil
        showNextAlertIfPresent()
    }
}
