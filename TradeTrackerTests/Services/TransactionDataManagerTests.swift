//
//  TransactionDataManagerTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 12.11.2024.
//

import XCTest
@testable import TradeTracker

final class TransactionDataManagerTests: XCTestCase {
    
    var mockDataLoader: MockDataLoader<[TransactionData]>!
    var sut: TransactionDataManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockDataLoader = MockDataLoader<[TransactionData]>()
        sut = TransactionDataManager(dataLoader: mockDataLoader)
    }
    
    override func tearDownWithError() throws {
        mockDataLoader = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testLoadTransactions_Success() {
        // Arrange
        let stubTransactions = getStubTransactions()
        mockDataLoader.result = .success(stubTransactions)
        
        // Act
        let result = sut.loadTransactions()
        
        // Assert
        switch result {
        case .success(let transactionData):
            XCTAssertEqual(transactionData.count, stubTransactions.count,
                           "Expected \(stubTransactions.count) but got \(transactionData.count)")
            
            XCTAssertEqual(transactionData.first?.sku, stubTransactions.first?.sku,
                           "Expected \(stubTransactions.first!.sku) but got \(transactionData.first!.sku)")
            
            XCTAssertEqual(transactionData.last?.sku, stubTransactions.last?.sku,
                           "Expected \(stubTransactions.last!.sku) but got \(transactionData.last!.sku)")
        case .failure:
            XCTFail("Expected .success but got .failure")
        }
    }
    
    
    func testLoadTransactions_Failure() {
        // Arrange
        mockDataLoader.result = .failure(.emptyTransactions)
        
        // Act
        let result = sut.loadTransactions()
        
        // Assert
        switch result {
        case .success:
            XCTFail("Expected .failure but got .success")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, DataServiceError.emptyTransactions.localizedDescription,
                           "Expected \(DataServiceError.emptyTransactions.localizedDescription) but got \(error.localizedDescription)")
        }
    }
    
    func testClearCache_RemoveAllTransactions() {
        // Arrange
        let stubTransactions = getStubTransactions()
        mockDataLoader.result = .success(stubTransactions)
        
        // Act
        let _ = sut.loadTransactions()
        sut.clearCache()

        // Assert
        XCTAssertEqual(sut.testCachedTransactions.count, 0,
                       "Expected 0 but got \(sut.testCachedTransactions)")
    }
    
    // Краевые случаи проверяю уровнем выше
    
    // MARK: - Helpers
    
    private func getStubTransactions() -> [TransactionData] {
        [TransactionData(sku: "SKU001", amount: "100.0", currency: "USD"),
         TransactionData(sku: "SKU002", amount: "200.0", currency: "GBP"),
         TransactionData(sku: "SKU002", amount: "100.0", currency: "USD"),
         TransactionData(sku: "SKU003", amount: "200.0", currency: "GBP"),
         TransactionData(sku: "SKU003", amount: "100.0", currency: "USD"),
         TransactionData(sku: "SKU003", amount: "200.0", currency: "GBP")]
    }
}

// MARK: - MockDataLoader

final class MockDataLoader<T: Decodable>: DataLoaderProtocol {
    
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
