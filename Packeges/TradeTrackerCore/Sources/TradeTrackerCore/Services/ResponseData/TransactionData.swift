//
//  TransactionData.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

public struct TransactionData: Codable {
    public let sku: String      // SKU продукта
    public let amount: String   // Сумма транзакции
    public let currency: String // Валюта транзакции
    
    public init(sku: String, amount: String, currency: String) {
        self.sku = sku
        self.amount = amount
        self.currency = currency
    }
}
