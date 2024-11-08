//
//  ProductsModelTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 06.11.2024.
//

import XCTest
@testable import TradeTracker

final class ProductsModelTests: XCTestCase {

    var stubRates: [RateData]!
    var stubTransactions: [TransactionData]!
    var dataManagerMock: DataManagerMock!
    var productsModel: ProductsModel!

    override func setUp() {
        super.setUp()
         stubRates = [
            RateData(from: "USD", to: "GBP", rate: "0.75"),
            RateData(from: "GBP", to: "EUR", rate: "1.25")
        ]
        
         stubTransactions = [
            TransactionData(sku: "SKU001", amount: "100.0", currency: "USD"),
            TransactionData(sku: "SKU002", amount: "200.0", currency: "GBP"),
            TransactionData(sku: "SKU002", amount: "100.0", currency: "USD"),
            TransactionData(sku: "SKU003", amount: "200.0", currency: "GBP"),
            TransactionData(sku: "SKU003", amount: "100.0", currency: "USD"),
            TransactionData(sku: "SKU003", amount: "200.0", currency: "GBP")
        ]
        

        
        dataManagerMock = DataManagerMock(stubRates: stubRates, stubTransactions: stubTransactions)
        productsModel = ProductsModel(dataManager: dataManagerMock)
    }

    func testLoadRatesSuccess() {
        dataManagerMock.shouldReturnFailureForTransactions = false
        let result = productsModel.getProductsInfo()
        
        switch result {
        case .success(let products):
            XCTAssertEqual(products.count, 3)
            
            XCTAssertEqual(products[0].transactionCount, "1")
            XCTAssertEqual(products[1].transactionCount, "2")
            XCTAssertEqual(products[2].transactionCount, "3")
            
            XCTAssertEqual(products[0].sku, "SKU001")
            XCTAssertEqual(products[1].sku, "SKU002")
            XCTAssertEqual(products[2].sku, "SKU003")

        case .failure:
            XCTFail("Expected success but got failure")
        }
    }

    func testLoadRatesFailure() {
        dataManagerMock.shouldReturnFailureForTransactions = true
        let result = productsModel.getProductsInfo()
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription,  DataServiceError.resourceNotFound(name: "transactions.plist").localizedDescription)
        }
    }
}

// MARK: - Mock Objects

final class DataManagerMock: TransactionDataManagerProtocol {
    var shouldReturnFailureForRates = false
    var shouldReturnFailureForTransactions = false

    var stubRates: [RateData]?
    var stubTransactions: [TransactionData]

    init(stubRates: [RateData]?, stubTransactions: [TransactionData]) {
        self.stubRates = stubRates
        self.stubTransactions = stubTransactions
    }

    func loadRates() -> Result<[RateData], DataServiceError> {
        if shouldReturnFailureForRates {
            return .failure(.resourceNotFound(name: "rates.plist"))
        } else {
            return .success(stubRates!)
        }
    }

    func loadTransactions() -> Result<[TransactionData], DataServiceError> {
        if shouldReturnFailureForTransactions {
            return .failure(.resourceNotFound(name: "transactions.plist"))
        } else {
            return .success(stubTransactions)
        }
    }

    func clearCache() {
        // Не обязательно для мок-тестов
    }
}
