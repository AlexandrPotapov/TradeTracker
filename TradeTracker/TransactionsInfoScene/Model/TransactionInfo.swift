//
//  TransactionInfo.swift
//  TradeTracker
//
//  Created by Alexander on 27.10.2024.
//

import Foundation

struct TransactionInfo {
    let fromCurrency: String    // Исходная валюта
    let fromAmount: Double      // Сумма в исходной валюте
    let toCurrency: String      // Целевая валюта (GBP)
    let toAmount: Double        // Сумма после конвертации в целевую валюту (GBP)
}
