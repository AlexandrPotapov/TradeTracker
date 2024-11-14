//
//  TransactionsInfoPresenter.swift
//  TradeTracker
//
//  Created by Alexander on 27.10.2024.
//

import Foundation

protocol TransactionsInfoViewProtocol: AnyObject {
    func success(viewModels: [TransactionsInfoViewModel])
}

protocol TransactionsInfoPresenterProtocol: AnyObject {
    func viewDidLoad()
    func getTransactionsTitle() -> String
    func getHeader() -> String
}

final class TransactionsInfoPresenter: TransactionsInfoPresenterProtocol {
    
    weak var view: TransactionsInfoViewProtocol?
    
    private var header: String = ""
    private var problemWithConversion = false // для обработки неудачных конвертаций
    private var problemWithСurrencySymbol = false // для обработки неудачных отображений символов
    private var badCurrencyCodes: [String] = []

    
    private let model: TransactionsInfoModelProtocol
    private let router: RouterTransactionInfoProtocol
    private let sku: String
    
    
    init(view: TransactionsInfoViewProtocol, model: TransactionsInfoModelProtocol, router: RouterTransactionInfoProtocol, sku: String) {
        self.view = view
        self.model = model
        self.router = router
        self.sku = sku
    }
    
    func viewDidLoad() {
        problemWithConversion = false // сбрасываем флаг
        problemWithСurrencySymbol = false
        
        let result = model.getTransactionsInfo(for: sku)
        switch result {
        case .success((let transactionsInfo, let totalInGBP)):
            
            header = totalAmount(total: totalInGBP)
            
            let viewModels = transactionsInfo.map {
                if  $0.toAmount == 0.0 {
                    problemWithConversion = true // покажим "-" для не удачных конвертаций
                    return TransactionsInfoViewModel(
                        fromCurrencyLabel: "\(currencySymbol(for: $0.fromCurrency)) \(formattedString(for: Double($0.fromAmount)))",
                        toCurrencyLabel: "-"
                    )
                } else {
                    return TransactionsInfoViewModel(
                        fromCurrencyLabel: "\(currencySymbol(for: $0.fromCurrency)) \(formattedString(for: Double($0.fromAmount)))",
                        toCurrencyLabel: "\(formattedString(for: Double($0.toAmount))) \(currencySymbol(for: $0.toCurrency))"
                    )
                }
            }
            
            if problemWithConversion {
                showAlertError(message: "Failed to concatenate some transactions. They will not be counted towards the total amount.")
            }
            
            if problemWithСurrencySymbol {
                showAlertError(message: "Currency symbols not found for \(badCurrencyCodes). Display: \"¤\"")
            }
            
            view?.success(viewModels: viewModels)
            
        case .failure(let error):
            showAlertError(message: error.localizedDescription)
        }
    }
    
    func getTransactionsTitle() -> String {
        return "Transactions for \(sku)"
    }
    
    func getHeader() -> String {
        return header
    }
}

// MARK: - Private Methods
private extension TransactionsInfoPresenter {
    
    func totalAmount(total: Double) -> String {
        return "Total: \(currencySymbol(for: "GBP")) \(formattedString(for: total))"
    }
    
    func currencySymbol(for currencyCode: String) -> String {
        if currencyCode == "USD" {
            return "$"
        }
        
        let localeIdentifier = Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode])
        let locale = Locale(identifier: localeIdentifier)
        
        guard let symbol = locale.currencySymbol, symbol != "¤" else {
            badCurrencyCodes.append(currencyCode)
            problemWithСurrencySymbol = true
            return "¤"
        }
        return symbol
    }
    
    func formattedString(for number: Double) -> String {
        
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
    
    func showAlertError(message: String) {
        router.showAlert(title: "Error", message: message)
    }
}
