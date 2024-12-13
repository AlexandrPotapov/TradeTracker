//
//  Transaction.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import Foundation

public struct Transaction {
    public let sku: String      // SKU продукта
    public let currency: String // Валюта транзакции
    public let amount: Double   // Сумма транзакции
    
    
    public init?(sku: String, currency: String, amount: String) {
        
        guard let amount = Double(amount) else { return nil }
        self.sku = sku
        self.currency = currency
        self.amount = amount
    }
}
