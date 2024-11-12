//
//  DataManagerWithRateTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 12.11.2024.
//

import XCTest
@testable import TradeTracker

final class DataManagerWithRateTests: XCTestCase {
    
    var mockRatesDataLoader: MockDataLoader<[RateData]>!
    var mockTransactionDataManager: MockTransactionDataManager!
    var sut: DataManagerWithRate!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRatesDataLoader = MockDataLoader<[RateData]>()
        mockTransactionDataManager = MockTransactionDataManager()
        sut = DataManagerWithRate(dataLoader: mockRatesDataLoader, transactionDataManager: mockTransactionDataManager)
    }
    
    override func tearDownWithError() throws {
        mockRatesDataLoader = nil
        mockTransactionDataManager = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testLoadRates_Success() {
        // Arrange
        let stubRates = getStubRates()
        mockRatesDataLoader.result = .success(stubRates)
        
        // Act
        let result = sut.loadRates()
        
        // Assert
        switch result {
        case .success(let ratesData):
            XCTAssertEqual(ratesData.count, stubRates.count,
                           "Expected \(stubRates.count) but got \(ratesData.count)")
            

        case .failure:
            XCTFail("Expected .success but got .failure")
        }
    }
    
    
    func testLoadRates_Failure() {
        // Arrange
        mockRatesDataLoader.result = .failure(.emptyRates)
        
        // Act
        let result = sut.loadRates()
        
        // Assert
        switch result {
        case .success:
            XCTFail("Expected .failure but got .success")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, DataServiceError.emptyRates.localizedDescription,
                           "Expected \(DataServiceError.emptyRates.localizedDescription) but got \(error.localizedDescription)")
        }
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
    private func getStubRates() -> [RateData] {
        [RateData(from: "USD", to: "GBP", rate: "1.2"),
         RateData(from: "AUSD", to: "USD", rate: "1.0")]
    }
}
