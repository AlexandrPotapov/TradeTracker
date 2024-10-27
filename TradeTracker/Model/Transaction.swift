//
//  Transaction.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

struct Transaction: Codable {
    let sku: String      // SKU продукта
    let amount: String   // Сумма транзакции
    let currency: String // Валюта транзакции
}
