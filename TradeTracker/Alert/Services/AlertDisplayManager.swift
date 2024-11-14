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
    
    private var alertWindow: AlertWindowProtocol?
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
        let newAlertWindow = alertPresenterFactory.makeAlertPresenter(delegate: self)
        newAlertWindow.presentAlert(alertController)
        
        self.alertWindow = newAlertWindow
    }
    
    // MARK: - AlertWindowDelegate
    
    func alertWindow(_ alertWindow: any AlertWindowProtocol, didDismissAlert alertController: UIViewController) {
        // убираем окно и показываем следующий алерт
        self.alertWindow = nil
        showNextAlertIfPresent()
    }
}


#if DEBUG
extension AlertDisplayManager {
    var testAlertWindow: AlertWindowProtocol? {
        get { alertWindow }
        set { alertWindow = newValue }
    }
}
#endif
