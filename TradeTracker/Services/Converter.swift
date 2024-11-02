//
//  Converter.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import Foundation

protocol ConverterProtocol {
    func convertToGBP(amount: Double, from currency: String, to targetCurrency: String, using rates: [Rate]) -> Double
}

struct Converter: ConverterProtocol {
    // Метод для конвертации валюты в GBP
     func convertToGBP(amount: Double, from currency: String, to targetCurrency: String, using rates: [Rate]) -> Double {
        guard currency != targetCurrency else { return amount }
        
        // Попробуем найти прямой курс для конверсии
        if let directRate = rates.first(where: { $0.from == currency && $0.to == targetCurrency }) {
            return amount * directRate.rate
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
                return amount * rate.rate
            } else {
                // Пытаемся найти курс до целевой валюты через промежуточные валюты
                let convertedAmount = amount * rate.rate
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
}
