//
//  DataManager.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

protocol DataManagerProtocol {
    init (dataLoader: DataLoader)
    func getProductsInfo() -> [Product]?
    func getTransactionsInfo(for sku: String) -> (transactions: [TransactionInfo], totalInGBP: Double)?
}

final class DataManager: DataManagerProtocol {
    
    private let dataLoader: DataLoader
    private var cachedTransactions: [Transaction]?

    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }
    
    // Приватные методы для загрузки данных
    private func loadRates() -> [Rate]? {
        guard let rateURL = Bundle.main.url(forResource: "rates", withExtension: "plist") else { return nil }
        return dataLoader.load(from: rateURL, as: [Rate].self)
    }
    
    private func loadTransactions() -> [Transaction]? {
        if cachedTransactions == nil {
            guard let transactionsURL = Bundle.main.url(forResource: "transactions", withExtension: "plist") else { return nil }
            cachedTransactions = dataLoader.load(from: transactionsURL, as: [Transaction].self)
        }
        return cachedTransactions
    }
    
    // Метод для конвертации валюты в GBP
    
    private func convertToGBP(amount: Double, from currency: String, to targetCurrency: String, using rates: [Rate]) -> Double {
        guard currency != targetCurrency else { return amount }
        
        // Попробуем найти прямой курс для конверсии
        if let directRate = rates.first(where: { $0.from == currency && $0.to == targetCurrency }) {
            return amount * Double(directRate.rate)!
        }
        
        // Рекурсивный поиск косвенного пути
        var visitedCurrencies = Set<String>() // Для отслеживания пройденных валют и предотвращения циклов
        return convert(amount: amount, from: currency, to: targetCurrency, using: rates, visitedCurrencies: &visitedCurrencies)
    }

    private func convert(amount: Double, from currency: String, to targetCurrency: String, using rates: [Rate], visitedCurrencies: inout Set<String>) -> Double {
        // Помечаем текущую валюту как пройденную
        visitedCurrencies.insert(currency)
        
        // Находим все доступные курсы из исходной валюты
        let availableRates = rates.filter { $0.from == currency && !visitedCurrencies.contains($0.to) }
        
        for rate in availableRates {
            if rate.to == targetCurrency {
                // Прямой курс найден на одном из шагов
                return amount * Double(rate.rate)!
            } else {
                // Пытаемся найти курс до целевой валюты через промежуточные валюты
                let convertedAmount = amount * Double(rate.rate)!
                let result = convert(amount: convertedAmount, from: rate.to, to: targetCurrency, using: rates, visitedCurrencies: &visitedCurrencies)
                
                // Если результат не равен исходной сумме, то конвертация удалась
                if result != convertedAmount {
                    return result
                }
            }
        }
        
        // Если путь не найден, возвращаем исходное значение
        return amount
    }
    
    // Метод для экрана Products: получает список SKU и количество транзакций для каждого SKU
    func getProductsInfo() -> [Product]? {
        guard let transactions = loadTransactions() else { return nil }
        
        let skuCounts = Dictionary(grouping: transactions, by: { $0.sku })
            .map { Product(sku: $0.key, transactionCount: String($0.value.count)) }
            .sorted { $0.sku < $1.sku }
        
        return skuCounts
    }
    
    // Метод для экрана Transactions: получает транзакции и итоговую сумму для данного SKU
    func getTransactionsInfo(for sku: String) -> (transactions: [TransactionInfo], totalInGBP: Double)? {
        guard
            let transactions = loadTransactions()?.filter({ $0.sku == sku }),
            let rates = loadRates()
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
            let toAmount = convertToGBP(amount: Double(fromAmount)!, from: fromCurrency, to: toCurrency, using: rates)
            
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
    
    // Метод очистки кэша
    func clearCache() {
        cachedTransactions = nil
    }
}
