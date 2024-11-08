//
//  Product.swift
//  TradeTracker
//
//  Created by Alexander on 08.11.2024.
//

import Foundation

struct Product: Equatable {
    let sku: String      // Идентификатор продукта
    let transactionCount: Int  // Количество транзакций для продукта
}
