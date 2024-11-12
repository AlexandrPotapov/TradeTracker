//
//  DataServiceError.swift
//  TradeTracker
//
//  Created by Alexander on 03.11.2024.
//

import Foundation

enum DataServiceError: Error {
    case resourceNotFound(name: String)
    case dataLoadingFailed(underlyingError: Error)
    case emptyTransactions
    case emptyRates
    case conversionFailed
    
    var localizedDescription: String {
        switch self {
        case .resourceNotFound(name: let name):
            return "Resource not found: \(name)"
        case .dataLoadingFailed(underlyingError: let error):
            return "Data loading failed: \(error)"
        case .emptyTransactions:
            return "Empty transactions"
        case .emptyRates:
            return "Empty rates"
        case .conversionFailed:
            return "Conversion failed"
        }
    }
}
