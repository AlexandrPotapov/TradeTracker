//
//  AlertDisplayManager.swift
//  TradeTracker
//
//  Created by Alexander on 14.11.2024.
//

import UIKit

protocol AlertDisplayManagerProtocol {
    func showNextAlertIfPresent()
}

final class AlertDisplayManager: AlertDisplayManagerProtocol, AlertWindowDelegate {
    
    private var alertWindow: AlertPresenterProtocol?
     var alertQueueManager: AlertQueueManagerProtocol?
    
    private let alertPresenterFactory: AlertPresenterFactoryProtocol
    
    init(alertPresenterFactory: AlertPresenterFactoryProtocol) {
        self.alertPresenterFactory = alertPresenterFactory
    }
    
    func showNextAlertIfPresent() {
        // Проверяем, что текущее окно свободно и есть алерт в очереди
        guard alertWindow == nil,
              let alertController = alertQueueManager?.dequeueAlert() else {
            return
        }
        
        // Создаем новое окно для отображения алерта
        var newAlertWindow = alertPresenterFactory.makeAlertPresenter()
        newAlertWindow.delegate = self
        newAlertWindow.presentAlert(alertController)
        
        self.alertWindow = newAlertWindow
    }
    
    // MARK: - AlertWindowDelegate

    func alertWindow(_ alertWindow: any AlertPresenterProtocol, didDismissAlert alertController: UIViewController) {
        // убираем окно и показываем следующий алерт
        self.alertWindow = nil
        showNextAlertIfPresent()
    }
}
