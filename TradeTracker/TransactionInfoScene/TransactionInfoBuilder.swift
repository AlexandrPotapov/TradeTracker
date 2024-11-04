//
//  TransactionInfoBuilder.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import UIKit

protocol TransactionInfoBuilderProtocol {
    func buildTransactionsInfo(product: ProductViewModel) -> UIViewController
}
final class TransactionInfoBuilder: TransactionInfoBuilderProtocol {
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func buildTransactionsInfo(product: ProductViewModel) -> UIViewController {
        let converter = Converter()
        let transactionsInfoModel = TransactionsInfoModel(converter: converter, dataManager: dataManager)
        
        let view = TransactionsInfoViewController()
        let router = RouterTransactionInfo(alertBuilder: AlertBuilder())
        let presenter = TransactionsInfoPresenter(view: view, model: transactionsInfoModel, router: router, product: product)
        view.presenter = presenter
        router.setRootViewController(root: view)
        return view
    }
}
