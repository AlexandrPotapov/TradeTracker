//
//  ProductsModel.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import Foundation

protocol ProductsModelProtocol {
    func getProductsInfo() -> Result<[ProductViewModel], DataServiceError>
}

struct ProductsModel: ProductsModelProtocol {
    
    let dataManager: DataManagerProtocol
    
    func getProductsInfo() -> Result<[ProductViewModel], DataServiceError> {
        let result = dataManager.loadTransactions()
        
        switch result {
        case .success(let transactions):
            
            let products = Dictionary(grouping: transactions, by: { $0.sku })
                .map { ProductViewModel(sku: $0.key, transactionCount: String($0.value.count)) }
                .sorted { $0.sku < $1.sku }
            return .success(products)
            
        case .failure(let error):
            return .failure(.dataLoadingFailed(underlyingError: error))
        }
    }
}
