//
//  ServicesMocks.swift
//  TradeTrackerTests
//
//  Created by Alexander on 08.12.2024.
//

import XCTest
@testable import TradeTracker

// MARK: - DataLoaderTests

struct TestData: Decodable {
    let name: String
    let value: Int
}

// MARK: - TransactionDataManagerTests

final class DataLoaderMock<T: Decodable>: DataLoaderProtocol {
    
    var result: Result<T, DataServiceError>?
    
    func load<U: Decodable>(from fileURL: URL, as type: U.Type) -> Result<U, DataServiceError> {
        // Преобразуем result в нужный тип
        if let result = result as? Result<U, DataServiceError> {
            return result
        } else {
            return .failure(.resourceNotFound(name: "Mock"))
        }
    }
}
