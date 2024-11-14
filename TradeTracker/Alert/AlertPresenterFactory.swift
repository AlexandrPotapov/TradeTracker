//
//  AlertPresenterFactory.swift
//  TradeTracker
//
//  Created by Alexander on 14.11.2024.
//

import Foundation

protocol AlertPresenterFactoryProtocol {
    func makeAlertPresenter() -> AlertPresenterProtocol
}

class AlertPresenterFactory: AlertPresenterFactoryProtocol {
    func makeAlertPresenter() -> AlertPresenterProtocol {
        return AlertWindow()
    }
}
