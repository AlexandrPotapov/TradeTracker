//
//  ModelProductsTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 06.11.2024.
//

import XCTest
@testable import TradeTracker

final class ModelProductsTests: XCTestCase {
    
    var mockDataManager: MockTransactionDataManager!
    var sut: ProductsModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockDataManager = MockTransactionDataManager()
        sut = ProductsModel(dataManager: mockDataManager)
    }
    
    override func tearDownWithError() throws {
        mockDataManager = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testGetProductsInfo_Success() {
        
        // Arrange
        mockDataManager.result = .success(getStubTransactions())
        
        // Act
        let result = sut.getProductsInfo()
        
        // Assert
        switch result {
        case .success(let products):
            XCTAssertEqual(products.count, 3,
                           "Expected 3 products but got \(products.count)")
            
            XCTAssertEqual(products[0].transactionCount, 1,
                           "Expected 1 transaction count but got \(products[0].transactionCount)")
            
            XCTAssertEqual(products[1].transactionCount, 2,
                           "Expected 2 transaction count but got \(products[1].transactionCount)")
            
            XCTAssertEqual(products[2].transactionCount, 3,
                           "Expected 3 transaction count but got \(products[3].transactionCount)")
            
            XCTAssertEqual(products[0].sku, "SKU001", "Expected SKU001 but got \(products[0].sku)")
            XCTAssertEqual(products[1].sku, "SKU002", "Expected SKU002 but got \(products[1].sku)")
            XCTAssertEqual(products[2].sku, "SKU003", "Expected SKU003 but got \(products[2].sku)")
            
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testGetProductsInfo_Failure() {
        
        // Arrange
        mockDataManager.result = .failure(.resourceNotFound(name: "transactions.plist"))
        
        // Act
        let result = sut.getProductsInfo()
        
        // Assert
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription,
                           DataServiceError.resourceNotFound(name: "transactions.plist").localizedDescription,
                           "Expected \"Resource not found: transactiowns.plist\" but got \"\(error.localizedDescription)\"")
        }
    }
    
    // MARK: - Edge Cases
    func testGetProductsInfo_WithEmptyTransactions() {
        
        // Arrange
        mockDataManager.result = .success([])
        
        // Act
        let result = sut.getProductsInfo()
        
        // Assert
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription,
                           DataServiceError.emptyTransactions.localizedDescription,
                           "Expected \"Empty transactions\" but got \"\(error.localizedDescription)\"")
        }
    }
    
    func testGetProductsInfo_WithOnlyOneTransaction() {
        // Arrange
        mockDataManager.result = .success([getStubTransactions().first!])
        
        // Act
        let result = sut.getProductsInfo()
        
        // Assert
        switch result {
        case .success(let products):
            XCTAssertEqual(products.count, 1,
                           "Expected 1 products but got \(products.count)")
            
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
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

// MARK: - MockTransactionDataManager

final class MockTransactionDataManager: TransactionDataManagerProtocol {
    
    var result: Result<[TransactionData], DataServiceError>?
        
    func loadTransactions() -> Result<[TransactionData], DataServiceError> {
        return result ?? .failure(.resourceNotFound(name: "Mock"))
    }
    
    func clearCache() {
        result = nil
    }
}
