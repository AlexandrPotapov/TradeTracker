//
//  Converter.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import Foundation

protocol ConverterProtocol {
    func convertToGBP(request: ConversionRequest) -> Result<Double, DataServiceError>
}

struct Converter: ConverterProtocol {
    // Метод для конвертации валюты в GBP
    func convertToGBP(request: ConversionRequest) -> Result<Double, DataServiceError> {
        guard request.fromCurrency != request.toCurrency else {
            return .success(request.amount)
        }
        
        // Попробуем найти прямой курс для конверсии
        if let directRate = request.rates.first(where: { $0.from == request.fromCurrency && $0.to == request.toCurrency }) {
            return .success(request.amount * directRate.rate)
        }
        
        // Рекурсивный поиск косвенного пути
        var visitedCurrencies = Set<String>() // Для отслеживания пройденных валют и предотвращения циклов
        let result = convert(request: request, visitedCurrencies: &visitedCurrencies)
        
        // Проверяем, была ли конвертация успешной
        return result > 0 ? .success(result) : .failure(.conversionFailed)
    }

    private func convert(request: ConversionRequest, visitedCurrencies: inout Set<String>) -> Double {
        // Помечаем текущую валюту как пройденную
        visitedCurrencies.insert(request.fromCurrency)
        
        // Находим все доступные курсы из исходной валюты
        let availableRates = request.rates.filter { $0.from == request.fromCurrency && !visitedCurrencies.contains($0.to) }
        
        for rate in availableRates {
            if rate.to == request.toCurrency {
                // Прямой курс найден на одном из шагов
                return request.amount * rate.rate
            } else {
                // Пытаемся найти курс до целевой валюты через промежуточные валюты
                let convertedAmount = request.amount * rate.rate
                let result = convert(request: ConversionRequest(amount: convertedAmount, fromCurrency: rate.to, toCurrency: request.toCurrency, rates: request.rates), visitedCurrencies: &visitedCurrencies)
                
                // Если результат не равен исходной сумме, то конвертация удалась
                if result != convertedAmount {
                    return result
                }
            }
        }
        
        // Если путь не найден, возвращаем 0 (обозначая неудачную конвертацию)
        return 0
    }
}
