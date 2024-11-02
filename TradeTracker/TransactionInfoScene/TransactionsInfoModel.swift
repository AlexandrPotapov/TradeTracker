//
//  TransactionsInfoModel.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import Foundation

struct TransactionsInfoModel {
    private let converter: ConverterProtocol
    let dataManager: DataManager

    
    func getTransactionsInfo(for sku: String) -> (transactions: [TransactionInfo], totalInGBP: Double)? {
        guard
            let transactions = dataManager.loadTransactions()?.filter({ $0.sku == sku }),
            let rates = dataManager.loadRates()
        else {
            return nil
        }
        
        var totalInGBP: Double = 0.0
        var transactionInfoList: [TransactionInfo] = []
        
        for transaction in transactions {
            let fromCurrency = transaction.currency
            let fromAmount = transaction.amount
            let toCurrency = "GBP"
            
            // Расчет суммы в GBP
            let toAmount = converter.convertToGBP(amount: Double(fromAmount)!, from: fromCurrency, to: toCurrency, using: rates)
            
            // Увеличиваем итоговую сумму в GBP
            totalInGBP += toAmount
            
            // Создаем модель TransactionInfo
            let transactionInfo = TransactionInfo(
                fromCurrency: fromCurrency,
                fromAmount: fromAmount,
                toCurrency: toCurrency,
                toAmount: String(toAmount)
            )
            
            transactionInfoList.append(transactionInfo)
        }
        
        return (transactionInfoList, totalInGBP)
    }
}
