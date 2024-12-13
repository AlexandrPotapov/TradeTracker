//
//  ProductsAssembly.swift
//  TradeTracker
//
//  Created by Alexander on 03.12.2024.
//

import Foundation
import Swinject
import UIKit
import TradeTrackerCore

final class ProductsAssembly: Assembly {
    func assemble(container: Container) {
        // Регистрация модели
        container.register(ProductsModelProtocol.self) { resolver in
            let dataManager = resolver.resolve(TransactionDataManagerProtocol.self)!
            return ProductsModel(dataManager: dataManager)
        }
        
        // Регистрация билдера для сцены TransactionInfoScene
        container.register(TransactionInfoBuilderProtocol.self) { resolver in
            TransactionsInfoBuilder(resolver: resolver)
        }
        
        //  Регистрация билдера для алерта
        container.register(AlertBuilderProtocol.self) { resolver in
            AlertBuilder(resolver: resolver)
        }
                
        // Регистрация роутера
        container.register(ProductsRouterProtocol.self) { resolver in
            ProductsRouter(
                transactionsInfoBuilder: resolver.resolve(TransactionInfoBuilderProtocol.self)!,
                alertBuilder:  resolver.resolve(AlertBuilderProtocol.self)!
            )
        }
        
        // Регистрация презентера
        container.register(ProductsPresenterProtocol.self) { resolver in
            let model = resolver.resolve(ProductsModelProtocol.self)!
            let router = resolver.resolve(ProductsRouterProtocol.self)!
            return ProductsPresenter(model: model, router: router)
        }
        
        // Регистрация ProductsViewController
        container.register(ProductsViewController.self) { resolver in
            let view = ProductsViewController()
            let presenter = resolver.resolve(ProductsPresenterProtocol.self)!
            view.presenter = presenter
            return view
        }.initCompleted { resolver, view in
            // После создания view связываем его с presenter
            let presenter = resolver.resolve(ProductsPresenterProtocol.self)!
            let router = resolver.resolve(ProductsRouterProtocol.self)!

            presenter.view = view
            router.setRootViewController(root: view)
        }
        
        // Регистрация ViewController
        container.register(UIViewController.self, name: "productsScene") { resolver in
            resolver.resolve(ProductsViewController.self)!
        }

    }
}

