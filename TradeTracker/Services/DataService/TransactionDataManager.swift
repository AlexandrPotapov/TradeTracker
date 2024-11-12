//
//  DataManager.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

protocol TransactionDataManagerProtocol {
    func loadTransactions() -> Result<[TransactionData], DataServiceError>
    func clearCache()
}

final class TransactionDataManager: TransactionDataManagerProtocol {
    
    private let dataLoader: DataLoaderProtocol
    private var cachedTransactions = [TransactionData]()
    
    init(dataLoader: DataLoaderProtocol) {
        self.dataLoader = dataLoader
    }
    
    func loadTransactions() -> Result<[TransactionData], DataServiceError> {
        guard let transactionsURL = Bundle.main.url(forResource: "transactions", withExtension: "plist") else { return .failure(.resourceNotFound(name: "transactions.plist")) }
        
        let result = dataLoader.load(from: transactionsURL, as: [TransactionData].self)
        
        switch result {
        case .success(let transactions):
            cachedTransactions = transactions
            return .success(cachedTransactions)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func clearCache() {
        cachedTransactions.removeAll()
    }
}

extension TransactionDataManager {
#if DEBUG
    var testCachedTransactions: [TransactionData] {
        cachedTransactions
    }
#endif
}
