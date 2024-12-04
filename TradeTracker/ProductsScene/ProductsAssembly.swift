//
//  ProductsAssembly.swift
//  TradeTracker
//
//  Created by Alexander on 03.12.2024.
//

import Foundation
import Swinject
import UIKit

final class ProductsAssembly: Assembly {
    func assemble(container: Container) {
        // Регистрация модели
        container.register(ProductsModelProtocol.self) { resolver in
            let dataManager = resolver.resolve(TransactionDataManagerProtocol.self)!
            return ProductsModel(dataManager: dataManager)
        }
        
        // Регистрация роутера
        container.register(RouterProductsProtocol.self) { resolver in
            RouterProducts(container: container)
        }
        
        // Регистрация презентера
        container.register(ProductsPresenterProtocol.self) { resolver in
            let model = resolver.resolve(ProductsModelProtocol.self)!
            let router = resolver.resolve(RouterProductsProtocol.self)!
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
            presenter.view = view
        }
        
        // Регистрация ViewController
        container.register(UIViewController.self, name: "productsScene") { resolver in
            resolver.resolve(ProductsViewController.self)!
        }
//        
//        container.register(ProductsViewProtocol.self) { resolver in
//            resolver.resolve(ProductsViewController.self)!
//        }
    }
}
