//
//  ProductsModel.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import Foundation

protocol ProductsModelProtocol {
    func getProductsInfo() -> Result<[Product], DataServiceError>
}

struct ProductsModel: ProductsModelProtocol {
    
    private let dataManager: TransactionDataManagerProtocol
    
    init(dataManager: TransactionDataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func getProductsInfo() -> Result<[Product], DataServiceError> {
        let result = dataManager.loadTransactions()
        
        switch result {
        case .success(let transactions):
            
            let products = Dictionary(grouping: transactions, by: { $0.sku })
                .map { Product(sku: $0.key, transactionCount: $0.value.count) }
                .sorted { $0.sku < $1.sku }
            return .success(products)
            
        case .failure(let error):
            return .failure(error)
        }
    }
}
