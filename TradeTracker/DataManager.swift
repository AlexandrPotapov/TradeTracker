//
//  DataManager.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

class DataManager {
    
    private let dataLoader: DataLoader

    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }
    
    func loadRates(from fileURL: URL) -> [Rate]? {
        return dataLoader.load(from: fileURL, as: [Rate].self)
    }
    
    func loadTransactions(from fileURL: URL) -> [Transaction]? {
        return dataLoader.load(from: fileURL, as: [Transaction].self)
    }
}
