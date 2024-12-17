//
//  DataManager.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

public protocol TransactionDataManagerProtocol {
    func loadTransactions() -> Result<[TransactionData], DataServiceError>
    func clearCache()
}

public final class TransactionDataManager: TransactionDataManagerProtocol {
    
    private let dataLoader: DataLoaderProtocol
    private var cachedTransactions = [TransactionData]()
    
    public init(dataLoader: DataLoaderProtocol) {
        self.dataLoader = dataLoader
    }
    
    public func loadTransactions() -> Result<[TransactionData], DataServiceError> {
        guard let transactionsURL = Bundle.module.url(forResource: "transactions", withExtension: "plist") else { return .failure(.resourceNotFound(name: "transactions.plist")) }
        
        let result = dataLoader.load(from: transactionsURL, as: [TransactionData].self)
        
        switch result {
        case .success(let transactions):
            cachedTransactions = transactions
            return .success(cachedTransactions)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func clearCache() {
        cachedTransactions.removeAll()
    }
}

extension TransactionDataManager {
#if DEBUG
    public var testCachedTransactions: [TransactionData] {
        cachedTransactions
    }
#endif
}
