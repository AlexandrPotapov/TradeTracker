//
//  ProductsSceneBuilder.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import UIKit

protocol ProductsBuilderProtocol {
    func buildProductScene() -> UIViewController
}

final class ProductsBuilder: ProductsBuilderProtocol {

    func buildProductScene() -> UIViewController {
        
        let dataLoader = PlistDataLoader()
        let dataManager = DataManager(dataLoader: dataLoader)
        
        let productsModel = ProductsModel(dataManager: dataManager)
        

        
        let router = RouterProducts(
            transactionsInfoBuilder: TransactionInfoBuilder(dataManager: dataManager),
            alertBuilder: AlertBuilder()
        )
        
        
        let view = ProductsViewController()
        let presenter = ProductsPresenter(view: view, model: productsModel, router: router)
        view.presenter = presenter
        router.setRootViewController(root: view)
        return view
    }
}
