//
//  TransactionsInfoAssembly.swift
//  TradeTracker
//
//  Created by Alexander on 03.12.2024.
//

import Foundation
import Swinject
import UIKit
import TradeTrackerCore


final class TransactionsInfoAssembly: Assembly {
    func assemble(container: Container) {
        
        // Регистрация AlertQueueManager
        container.register(ConverterProtocol.self) { _ in Converter() }
        
        // Регистрация AlertQueueManager
        container.register(AlertQueueManagerProtocol.self) { _ in AlertQueueManager() }
        
        // Регистрация AlertDisplayManager
        container.register(AlertDisplayManagerProtocol.self) { resolver in
            let alertDisplayManager = AlertDisplayManager(alertPresenterFactory: AlertPresenterFactory())
            alertDisplayManager.alertQueueManager = resolver.resolve(AlertQueueManagerProtocol.self)
            return alertDisplayManager
        }
        
        // Регистрация AlertBuilder
        container.register(AlertBuilderProtocol.self) { resolver in AlertBuilder(resolver: resolver) }
        
        // Регистрация RouterTransactionInfo
        container.register(TransactionInfoRouterProtocol.self) { resolver in
            guard let alertQueueManager = resolver.resolve(AlertQueueManagerProtocol.self),
                  let alertDisplayManager = resolver.resolve(AlertDisplayManagerProtocol.self),
            let alertBuilder = resolver.resolve(AlertBuilderProtocol.self) else {
                fatalError("Failed to resolve dependencies for RouterTransactionInfo")
            }
            return TransactionInfoRouter(
                alertQueueManager: alertQueueManager,
                alertDisplayManager: alertDisplayManager,
                alertBuilder: alertBuilder
            )
        }
        
        // Регистрация TransactionsInfoModel
        container.register(TransactionsInfoModelProtocol.self) { resolver in
            guard let converter = resolver.resolve(ConverterProtocol.self),
                  let dataManager = resolver.resolve(DataManagerWithRateProtocol.self) else {
                fatalError("Failed to resolve dependencies for TransactionsInfoModel")
            }
            return TransactionsInfoModel(converter: converter, dataManager: dataManager)
        }
        
        // Регистрация TransactionsInfoPresenter
        container.register(TransactionsInfoPresenterProtocol.self) { (resolver, sku: String) in
            guard let model = resolver.resolve(TransactionsInfoModelProtocol.self),
                  let router = resolver.resolve(TransactionInfoRouterProtocol.self) else {
                fatalError("Failed to resolve dependencies for TransactionsInfoPresenter")
            }
            return TransactionsInfoPresenter(model: model, router: router, sku: sku)
        }
        
        // Регистрация TransactionsInfoViewController
        container.register(TransactionsInfoViewController.self) { (resolver, sku: String) in
            guard let presenter = resolver.resolve(TransactionsInfoPresenterProtocol.self, argument: sku) else {
                fatalError("Failed to resolve dependencies for TransactionsInfoViewController")
            }
            let view = TransactionsInfoViewController()
            view.presenter = presenter
            presenter.view = view
            return view
        }
        
        // Регистрация ViewController
        container.register(UIViewController.self, name: "transactionsInfoScene") { (resolver, sku: String) in
            resolver.resolve(TransactionsInfoViewController.self, argument: sku)!
        }
    }
}
