//
//  TransactionsInfoModel.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import Foundation

protocol TransactionsInfoModelProtocol {
    func getTransactionsInfo(for sku: String) -> Result<(transactions: [TransactionInfo], totalInGBP: Double), DataServiceError>
}

struct TransactionsInfoModel: TransactionsInfoModelProtocol {
    let converter: ConverterProtocol
    let dataManager: DataManagerProtocol
    
    func getTransactionsInfo(for sku: String) -> Result<(transactions: [TransactionInfo], totalInGBP: Double), DataServiceError> {
        switch getTransactions() {
        case .failure(let error):
            return .failure(error)
        case .success(let transactions):
            switch getRates() {
            case .failure(let error):
                return .failure(error)
            case .success(let rates):
                let filteredTransactions = transactions.filter { $0.sku == sku }
                
                var totalInGBP: Double = 0.0
                var transactionInfoList: [TransactionInfo] = []
                
                for transaction in filteredTransactions {
                    let fromCurrency = transaction.currency
                    let fromAmount = transaction.amount
                    let toCurrency = "GBP"
                    
                    // Конвертация суммы в GBP
                    let toAmount = converter.convertToGBP(amount: fromAmount,
                                                          from: fromCurrency,
                                                          to: toCurrency,
                                                          using: rates)
                    
                    // Увеличиваем итоговую сумму в GBP
                    totalInGBP += toAmount
                    
                    // Создаем модель TransactionInfo
                    let transactionInfo = TransactionInfo(
                        fromCurrency: fromCurrency,
                        fromAmount: fromAmount,
                        toCurrency: toCurrency,
                        toAmount: toAmount
                    )
                    
                    transactionInfoList.append(transactionInfo)
                }
                
                return .success((transactionInfoList, totalInGBP))
            }
        }
    }
}

// MARK: - Private Methods
private extension TransactionsInfoModel {
    func getRates() -> Result<[Rate], DataServiceError> {
        let result = dataManager.loadRates()
        switch result {
            case .success(let rates):
            return .success(rates.compactMap {
                Rate(from: $0.from, to: $0.to, rate: $0.rate)
            })
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getTransactions() -> Result<[Transaction], DataServiceError> {
        let result =  dataManager.loadTransactions()
        switch result {
            case .success(let transactions):
            return .success(transactions.compactMap {
                Transaction(sku:  $0.sku, currency:  $0.currency, amount:  $0.amount)
            })
        case .failure(let error):
            return .failure(error)
        }
    }
}
