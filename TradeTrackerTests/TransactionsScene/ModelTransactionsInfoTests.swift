//
//  ModelTransactionsInfoTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 12.11.2024.
//

import XCTest
@testable import TradeTracker

final class ModelTransactionsInfoTests: XCTestCase {
    
    var mockDataManager: MockDataManagerWithRates!
    var mockConverter: MockConverter!
    var sut: TransactionsInfoModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockDataManager = MockDataManagerWithRates()
        mockConverter = MockConverter()
        
        sut = TransactionsInfoModel(converter: mockConverter, dataManager: mockDataManager)
    }
    
    override func tearDownWithError() throws {
        mockDataManager = nil
        mockConverter = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testGetTransactionsInfo_Success() {
        
        // Arrange
        let stubTransactions = getStubTransactions()
        let stubRates = getStubRates()
        let stubConverterResult = 100.0
        
        mockConverter.converterResult = .success(stubConverterResult)
        mockDataManager.transactionsResult = .success(stubTransactions)
        mockDataManager.ratesResult = .success(stubRates)
        
        // Act
        let result =  sut.getTransactionsInfo(for: "SKU003") // для данного SKU есть три транзакции
        
        // Assert
        switch result {
        case .success((let transactions, let totalInGBP)):
            XCTAssertEqual(transactions.count, 3, "Expected 3 but got \(transactions.count)")
            
            let expected = Double(transactions.count) * stubConverterResult
            XCTAssertEqual(totalInGBP, expected, "Expected \(expected) but got \(totalInGBP)")
                        
            XCTAssertEqual(transactions.last?.fromCurrency, "USD",
                           "Expected USD but got \(transactions.last!.fromAmount)")
            
            XCTAssertEqual(transactions.last?.fromAmount, 300.0,
                           "Expected 300.0 but got \(transactions.last!.fromAmount)")
            
            XCTAssertEqual(transactions.last?.toCurrency, "GBP",
                           "Expected GBP but got \(transactions.last!.fromAmount)")
            
            XCTAssertEqual(transactions.last?.toAmount, stubConverterResult,
                           "Expected \(stubConverterResult) but got \(transactions.last!.toAmount)")

        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testGetTransactionsInfo_Failure() {
        
        // Arrange
        let stubTransactions = getStubTransactions()
        
        mockDataManager.transactionsResult = .success(stubTransactions)
        mockDataManager.ratesResult = .failure(.resourceNotFound(name: "rates.plist"))
        
        // Act
        let result =  sut.getTransactionsInfo(for: "SKU003") // для данного SKU есть три транзакции

        // Assert
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription,
                           DataServiceError.resourceNotFound(name: "rates.plist").localizedDescription,
                           "Expected \"Resource not found: rates.plist\" but got \"\(error.localizedDescription)\"")
        }
        
    }
    
    func testGetTransactionsInfo_WithEmptyRates() {
        
        // Arrange
        let stubTransactions = getStubTransactions()
        let stubRates = [RateData]()
        
        mockDataManager.transactionsResult = .success(stubTransactions)
        mockDataManager.ratesResult = .success(stubRates)
        
        // Act
        let result =  sut.getTransactionsInfo(for: "Foo") // для данного SKU есть три транзакции
        
        // Assert
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription,
                           DataServiceError.emptyRates.localizedDescription,
                           "Expected \"Empty rates\" but got \"\(error.localizedDescription)\"")
        }
    }
    
    func testGetTransactionsInfo_WithConvertorFailure() {
        
        // Arrange
        let stubTransactions = getStubTransactions()
        let stubRates = getStubRates()
        
        mockConverter.converterResult = .failure(.conversionFailed)
        mockDataManager.transactionsResult = .success(stubTransactions)
        mockDataManager.ratesResult = .success(stubRates)
        
        // Act
        let result =  sut.getTransactionsInfo(for: "SKU003") // для данного SKU есть три транзакции
        
        // Assert
        switch result {
        case .success((let transactions, let totalInGBP)):
            XCTAssertEqual(transactions.count, 3, "Expected 3 but got \(transactions.count)")
            
            // все наши конвертации неуспешные (toAmount = 0.0), что в сумме = 0.0
            XCTAssertEqual(totalInGBP, 0.0, "Expected 0.0 but got \(totalInGBP)")
            
            XCTAssertEqual(transactions.last?.toAmount, 0.0,
                           "Expected 0.0 but got \(transactions.last!.toAmount)")

        case .failure:
            XCTFail("Expected success but got failure")
        }
        
        
    }
    
    // MARK: - Helpers
    
    private func getStubTransactions() -> [TransactionData] {
        [TransactionData(sku: "SKU001", amount: "100.0", currency: "USD"),
         TransactionData(sku: "SKU002", amount: "100.0", currency: "USD"),
         TransactionData(sku: "SKU002", amount: "200.0", currency: "USD"),
         TransactionData(sku: "SKU003", amount: "100.0", currency: "USD"),
         TransactionData(sku: "SKU003", amount: "200.0", currency: "USD"),
         TransactionData(sku: "SKU003", amount: "300.0", currency: "USD")]
    }
    
    private func getStubRates() -> [RateData] {
        [RateData(from: "Foo", to: "Bar", rate: "Baz"),
         RateData(from: "Foo1", to: "Bar1", rate: "Baz1")]
    }
}

// MARK: - MockTransactionDataManager

final class MockDataManagerWithRates: DataManagerWithRateProtocol {
    
    var transactionsResult: Result<[TransactionData], DataServiceError>?
    var ratesResult: Result<[RateData], DataServiceError>?
    
    func loadRates() -> Result<[RateData], DataServiceError> {
        ratesResult ?? .failure(.resourceNotFound(name: "Mock"))
    }
    
    func loadTransactions() -> Result<[TransactionData], DataServiceError> {
        transactionsResult ?? .failure(.resourceNotFound(name: "Mock"))
    }
    
    func clearCache() {
    }
    
    
}

final class MockConverter: ConverterProtocol {
    
    var converterResult: Result<Double, TradeTracker.DataServiceError>?

    func convertToGBP(request: TradeTracker.ConversionRequest) -> Result<Double, TradeTracker.DataServiceError> {
        converterResult ?? .failure(.resourceNotFound(name: "Mock"))
    }
}

