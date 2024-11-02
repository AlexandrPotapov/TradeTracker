//
//  TransactionInfoSceneBuilder.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import UIKit

protocol TransactionInfoSceneBuilderProtocol {
    func buildTransactionsInfo(product: Product?) -> UIViewController
}
final class TransactionInfoSceneBuilder: TransactionInfoSceneBuilderProtocol {
    
    private let dataManager: DataManagerProtocol

    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func buildTransactionsInfo(product: Product?) -> UIViewController {
        let converter = Converter()
        let transactionsInfoModel = TransactionsInfoModel(converter: converter, dataManager: dataManager)
        
        let view = TransactionsInfoViewController()
        let router = RouterTransactionInfoScene(alertBuilder: AlertBuilder())
        let presenter = TransactionsInfoPresenter(view: view, model: transactionsInfoModel, router: router, product: product)
        view.presenter = presenter
        router.setRootViewController(root: view)
        return view
    }
}
