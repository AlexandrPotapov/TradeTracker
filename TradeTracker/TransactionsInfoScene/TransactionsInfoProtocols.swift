//
//  TransactionsInfoProtocols.swift
//  TradeTracker
//
//  Created by Alexander on 04.12.2024.
//

import UIKit
import TradeTrackerCore


protocol TransactionsInfoModelProtocol {
    func getTransactionsInfo(for sku: String) -> Result<(transactions: [TransactionInfo], totalInGBP: Double), DataServiceError>
}

protocol TransactionsInfoViewProtocol: AnyObject {
    var presenter: TransactionsInfoPresenterProtocol? { get set }
    func success(viewModels: [TransactionsInfoViewModel])
}

protocol TransactionsInfoPresenterProtocol: AnyObject {
    var view: TransactionsInfoViewProtocol? { get set }
    func viewDidLoad()
    func getTransactionsTitle() -> String
    func getHeader() -> String
}

protocol TransactionInfoBuilderProtocol {
    func buildTransactionsInfo(with sku: String) -> UIViewController
}

protocol TransactionInfoRouterProtocol{
    func showAlert(title: String, message: String)
}
