//
//  AlertPresenterFactory.swift
//  TradeTracker
//
//  Created by Alexander on 14.11.2024.
//

import Foundation

protocol AlertPresenterFactoryProtocol {
    func makeAlertPresenter(delegate: AlertWindowDelegate) -> AlertWindowProtocol
}

class AlertPresenterFactory: AlertPresenterFactoryProtocol {
    func makeAlertPresenter(delegate: AlertWindowDelegate) -> AlertWindowProtocol {
        return AlertWindow(delegate: delegate)
    }
}
