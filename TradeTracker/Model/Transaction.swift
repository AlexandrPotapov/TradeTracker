//
//  Transaction.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import Foundation

struct Transaction {
    let sku: String      // SKU продукта
    let currency: String // Валюта транзакции
    let amount: Double   // Сумма транзакции

    
    init?(sku: String, currency: String, amount: String) {
        self.sku = sku
        self.currency = currency
        
        if let amount = Double(amount) {
            self.amount = amount
        } else {
            return nil
        }
    }
    
}
