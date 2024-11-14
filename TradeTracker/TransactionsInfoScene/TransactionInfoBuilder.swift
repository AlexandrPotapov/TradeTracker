//
//  TransactionInfoBuilder.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import UIKit

protocol TransactionInfoBuilderProtocol {
    func buildTransactionsInfo(with sku: String) -> UIViewController
}
final class TransactionInfoBuilder: TransactionInfoBuilderProtocol {
    
    private let dataManager: DataManagerWithRateProtocol
    
    init(dataManager: DataManagerWithRateProtocol) {
        self.dataManager = dataManager
    }
    
    func buildTransactionsInfo(with sku: String) -> UIViewController {
        let converter = Converter()
        let transactionsInfoModel = TransactionsInfoModel(converter: converter, dataManager: dataManager)
        
        let view = TransactionsInfoViewController()
        
        let queue = AlertQueueManager()
        let alertDisplayManager =  AlertDisplayManager(alertPresenterFactory: AlertPresenterFactory())
        alertDisplayManager.alertQueueManager = queue
        
        let router = RouterTransactionInfo(alertQueueManager: queue,
                                           alertDisplayManager: alertDisplayManager,
                                           alertBuilder: AlertBuilder())
        
        let presenter = TransactionsInfoPresenter(view: view, model: transactionsInfoModel, router: router, sku: sku)
        view.presenter = presenter
        return view
    }
}
