//
//  DataManagerWithRate.swift
//  TradeTracker
//
//  Created by Alexander on 08.11.2024.
//

import Foundation

protocol DataManagerWithRateProtocol: TransactionDataManagerProtocol {
    func loadRates() -> Result<[RateData], DataServiceError>
}

final class DataManagerWithRate: DataManagerWithRateProtocol {
    private let transactionDataManager: TransactionDataManagerProtocol
    private let dataLoader: DataLoaderProtocol

    init(dataLoader: DataLoaderProtocol, transactionDataManager: TransactionDataManagerProtocol) {
        self.dataLoader = dataLoader
        self.transactionDataManager = transactionDataManager
    }
    
    func loadRates() -> Result<[RateData], DataServiceError> {
        guard let rateURL = Bundle.main.url(forResource: "rates", withExtension: "plist") else {
            return .failure(.resourceNotFound(name: "rates.plist"))
        }
        
        return dataLoader.load(from: rateURL, as: [RateData].self)
    }

    // Методы для работы с транзакциями делегируются transactionDataManager
    func loadTransactions() -> Result<[TransactionData], DataServiceError> {
        return transactionDataManager.loadTransactions()
    }

    func clearCache() {
        transactionDataManager.clearCache()
    }
}
