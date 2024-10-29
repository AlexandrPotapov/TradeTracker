//
//  TransactionsInfoPresenter.swift
//  TradeTracker
//
//  Created by Alexander on 27.10.2024.
//

import Foundation


struct TransactionsInfoViewModel {
    let fromCurrencyLabel: String
    let toCurrencyLabel: String
}

protocol TransactionsInfoViewProtocol: AnyObject {
    func success()
}

protocol TransactionsInfoPresenterProtocol: AnyObject {
    var viewModels: [TransactionsInfoViewModel]? { get set }
    var header: String? { get set }
    var title: String? { get }
    init(view: TransactionsInfoViewProtocol, dataManager: DataManagerProtocol, router: RouterProtocol, product: Product?)
    func viewDidLoad()
}

final class TransactionsInfoPresenter: TransactionsInfoPresenterProtocol {
    
    weak var view: TransactionsInfoViewProtocol?
    var viewModels: [TransactionsInfoViewModel]?
    var header: String?
    
    var title: String? {
        getTransactionsTitle()
    }

    private let dataManager: DataManagerProtocol!
    private let router: RouterProtocol!
    private let product: Product?
    
    init(view: TransactionsInfoViewProtocol, dataManager: DataManagerProtocol, router: RouterProtocol, product: Product?) {
        self.view = view
        self.dataManager = dataManager
        self.router = router
        self.product = product
    }
    
    func viewDidLoad() {
        guard
            let product = product,
            let transactionsInfo = dataManager.getTransactionsInfo(for: product.sku)
        else {
            showAlertError(message: "Erorr loading transactions")
            return
        }

        let transactions = transactionsInfo.transactions
        header = totalAmount(total: String(transactionsInfo.totalInGBP))

        viewModels = transactions.map {
             TransactionsInfoViewModel(
                fromCurrencyLabel: "\(currencySymbol(for: $0.fromCurrency)) \(formattedString(for: Double($0.fromAmount)))",
                toCurrencyLabel: "\(formattedString(for: Double($0.toAmount))) \(currencySymbol(for: $0.toCurrency))"
             )
         }

         view?.success()
     }
    private func getTransactionsTitle() -> String {
        guard let product = product else {
            showAlertError(message: "Failed to retrieve total amount.")
            return "Transactions for Error"
        }
        return "Transactions for \(product.sku)"
    }

    private func totalAmount(total: String?) -> String {
        guard let total = total, let totalValue = Double(total) else {
            showAlertError(message: "Failed to retrieve total amount.")
            return "Total: -"
        }
        return "Total: \(currencySymbol(for: "GBP")) \(formattedString(for: totalValue))"
    }

    private func currencySymbol(for currencyCode: String) -> String {
        if currencyCode == "USD" {
            return "$"
        }
        
        let localeIdentifier = Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode])
        let locale = Locale(identifier: localeIdentifier)
        
        guard let symbol = locale.currencySymbol else {
            showAlertError(message: "Currency symbol not found for \(currencyCode).")
            return currencyCode
        }
        return symbol
    }
    
    private func formattedString(for number: Double?) -> String {
        guard let number else {
            showAlertError(message: "Invalid number format.")
            return ""
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.minimumFractionDigits = 2 // Минимум 2 знака после запятой
        formatter.maximumFractionDigits = 2 // Максимум 2 знака после запятой
        
        guard let formattedNumber = formatter.string(from: NSNumber(value: number)) else {
            showAlertError(message: "Failed to format number.")
            return "\(number)"
        }
        
        return formattedNumber
    }
    
    private func showAlertError(message: String) {
        router?.showAlert(title: "Error", message: message)
    }
    
}
