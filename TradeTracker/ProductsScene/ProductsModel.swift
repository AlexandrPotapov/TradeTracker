//
//  ProductsModel.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import Foundation

struct ProductsModel {
    
    let dataManager: DataManager
    
    func getProductsInfo() -> [Product]? {
            guard let transactions = dataManager.loadTransactions() else { return nil }
            
            let products = Dictionary(grouping: transactions, by: { $0.sku })
                .map { Product(sku: $0.key, transactionCount: String($0.value.count)) }
                .sorted { $0.sku < $1.sku }
            
            return products
        
    }
}
