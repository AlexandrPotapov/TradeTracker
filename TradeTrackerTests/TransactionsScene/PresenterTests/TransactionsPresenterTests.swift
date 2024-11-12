//
//  TransactionsPresenterTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 08.11.2024.
//

import XCTest
@testable import TradeTracker

final class TransactionsPresenterTests: XCTestCase {
    
    var mockView: MockTransactionsInfoView!
    var mockModel: MockTransactionsInfoModel!
    var mockRouter: MockRouterTransactionsInfo!
    var sut: TransactionsInfoPresenter!
    
    // Общие значения для большинства тестов
    var stubTransactions: [TransactionInfo]!
    var stubTotalInGBP: Double!
    var stubSKU: String!

    override func setUpWithError() throws {
        
        try super.setUpWithError()
        mockView = MockTransactionsInfoView()
        mockModel = MockTransactionsInfoModel()
        mockRouter = MockRouterTransactionsInfo()
        
        stubTransactions = createStubTransactions()
        stubTotalInGBP = 1000.0
        stubSKU = "Foo"
        
        sut = TransactionsInfoPresenter(view: mockView, model: mockModel, router: mockRouter, sku: stubSKU)
    }

    override func tearDownWithError() throws {
        mockView = nil
        mockModel = nil
        mockRouter = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testViewDidLoad_Success() throws {
        
        // Arrange
        mockModel.result = .success((transactions: stubTransactions, totalInGBP: stubTotalInGBP))
        
        // Act
        sut.viewDidLoad()
        
        // Assert
        XCTAssertTrue(mockView.successCalled)
        XCTAssertEqual(mockView.viewModels.count, stubTransactions.count)
        
        XCTAssertEqual(mockView.viewModels.first?.fromCurrencyLabel, "$ 100,00")
        XCTAssertEqual(mockView.viewModels.first?.toCurrencyLabel, "100,00 £")
        
        XCTAssertEqual(mockView.viewModels[1].fromCurrencyLabel, "$ 200,00")
        XCTAssertEqual(mockView.viewModels[1].toCurrencyLabel, "200,00 £")
        
        XCTAssertEqual(mockView.viewModels[2].fromCurrencyLabel, "$ 300,00")
        XCTAssertEqual(mockView.viewModels[2].toCurrencyLabel, "300,00 £")
    }
    
//    func testViewDidLoad_WithSingleTransaction() throws {
//        
//        // Arrange
//        let singleTransaction = [TransactionInfo(fromCurrency: "USD", fromAmount: 100.0, toCurrency: "GBP", toAmount: 100.0)]
//        mockModel.result = .success((transactions: singleTransaction, totalInGBP: 100.0))
//        
//        // Act
//        sut.viewDidLoad()
//        
//        // Assert
//        XCTAssertTrue(mockView.successCalled)
//        XCTAssertEqual(mockView.viewModels.count, 1)
//        XCTAssertEqual(mockView.viewModels.first?.fromCurrencyLabel, "$ 100,00")
//        XCTAssertEqual(mockView.viewModels.first?.toCurrencyLabel, "100,00 £")
//        XCTAssertEqual(sut.getHeader(), "Total: £ 100,00")
//    }
//    
//    func testViewDidLoadWithNoTransactions() throws {
//        
//        // Arrange
//        mockModel.result = .success((transactions: [], totalInGBP: 0.0))
//        
//        // Act
//        sut.viewDidLoad()
//        
//        // Assert
//        XCTAssertTrue(mockView.successCalled)
//        XCTAssertTrue(mockView.viewModels.isEmpty)
//        XCTAssertEqual(sut.getHeader(), "Total: £ 0,00")
//    }
    
    func testViewDidLoadFailure() throws {
        
        // Arrange
        mockModel.result = .failure(.resourceNotFound(name: "Bar"))
        
        // Act
        sut.viewDidLoad()
        
        // Assert
        XCTAssertFalse(mockView.successCalled)
        XCTAssertNil(mockView.viewModels.first?.fromCurrencyLabel)
        XCTAssertNil(mockView.viewModels.first?.toCurrencyLabel)
        XCTAssertTrue(mockRouter.alertShown)
        XCTAssertEqual(mockRouter.alertMessage, "Resource not found: Bar")
    }
    
    func testGetHeaderSetsDesiredHeader() throws {
        
        // Arrange
        mockModel.result = .success((transactions: stubTransactions, totalInGBP: stubTotalInGBP))
        
        // Act
        sut.viewDidLoad()
        
        
        // Assert
        XCTAssertTrue(mockView.successCalled)
        XCTAssertEqual(sut.getHeader(), "Total: £ 1 000,00")
    }
    
    func testGetTitleSetsDesiredTitle() throws {
        
        // Arrange
        mockModel.result = .success((transactions: stubTransactions, totalInGBP: stubTotalInGBP))
        
        // Act
        sut.viewDidLoad()
        
        // Assert
        XCTAssertTrue(mockView.successCalled)
        XCTAssertEqual(sut.getTransactionsTitle(), "Transactions for \(stubSKU!)")
    }
    
    // MARK: - Helpers
    
    private func createStubTransactions() -> [TransactionInfo] {
        return [
            TransactionInfo(fromCurrency: "USD", fromAmount: 100.0, toCurrency: "GBP", toAmount: 100.0),
            TransactionInfo(fromCurrency: "USD", fromAmount: 200.0, toCurrency: "GBP", toAmount: 200.0),
            TransactionInfo(fromCurrency: "USD", fromAmount: 300.0, toCurrency: "GBP", toAmount: 300.0)
        ]
    }
}

// MARK: - Mocks Objects

final class MockTransactionsInfoView: TransactionsInfoViewProtocol {
    
    var successCalled = false
    var viewModels: [TransactionsInfoViewModel] = []
    
    func success(viewModels: [TransactionsInfoViewModel]) {
        successCalled = true
        self.viewModels = viewModels
    }
}

final class MockTransactionsInfoModel: TransactionsInfoModelProtocol {
    
    var result: Result<(transactions: [TransactionInfo], totalInGBP: Double), DataServiceError>?

    func getTransactionsInfo(for sku: String) -> Result<(transactions: [TransactionInfo], totalInGBP: Double), DataServiceError> {
        return result ?? .failure(.resourceNotFound(name: "Mock"))
    }
}

final class MockRouterTransactionsInfo: RouterTransactionInfoProtocol {
    
    var alertShown = false
    var alertMessage: String?

    func showAlert(title: String, message: String) {
        alertShown = true
        alertMessage = message
    }
}
