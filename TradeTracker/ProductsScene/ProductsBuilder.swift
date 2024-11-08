//
//  ProductsBuilder.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import UIKit

protocol ProductsBuilderProtocol {
    func buildProduct() -> UIViewController
}

final class ProductsBuilder: ProductsBuilderProtocol {
    
    func buildProduct() -> UIViewController {
        
        let dataLoader = DataLoader()
        let transactionDataManager = TransactionDataManager(dataLoader: dataLoader)
        let dataManagerWithRate = DataManagerWithRate(dataLoader: dataLoader, transactionDataManager: transactionDataManager)
        let productsModel = ProductsModel(dataManager: transactionDataManager)
        
        let router = RouterProducts(
            transactionsInfoBuilder: TransactionInfoBuilder(dataManager: dataManagerWithRate),
            alertBuilder: AlertBuilder()
        )
        
        let view = ProductsViewController()
        let presenter = ProductsPresenter(view: view,
                                          model: productsModel,
                                          router: router)
        view.presenter = presenter
        router.setRootViewController(root: view)
        return view
    }
}
