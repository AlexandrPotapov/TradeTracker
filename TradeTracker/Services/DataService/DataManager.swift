//
//  DataManager.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

protocol DataManagerProtocol {
    func loadRates() -> Result<[RateData], DataServiceError>
    func loadTransactions() -> Result<[TransactionData], DataServiceError>
    func clearCache()
}

final class DataManager: DataManagerProtocol {
    
    private let dataLoader: DataLoader
    private var cachedTransactions = [TransactionData]() // чтобы не делать лишний запрос
    
    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }
    
    func loadRates() -> Result<[RateData], DataServiceError> {
        guard let rateURL = Bundle.main.url(forResource: "rates", withExtension: "plist") else { return .failure(.resourceNotFound(name: "rates.plist")) }
        
        return dataLoader.load(from: rateURL, as: [RateData].self)
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
