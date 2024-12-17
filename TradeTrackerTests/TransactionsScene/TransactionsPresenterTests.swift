//
//  PresenterTransactionsTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 08.11.2024.
//

import XCTest
@testable import TradeTracker
import TradeTrackerCore
import Features


final class TransactionsPresenterTests: XCTestCase {
    
    var mockView: TransactionsInfoViewMock!
    var mockModel: MockTransactionsInfoModel!
    var mockRouter: MockRouterTransactionsInfo!
    var sut: TransactionsInfoPresenter!
    
    // Общие значения для большинства тестов
    var stubTransactions: [TransactionInfo]!
    var stubTotalInGBP: Double!
    var stubSKU: String!

    override func setUpWithError() throws {
        
        try super.setUpWithError()
        mockView = TransactionsInfoViewMock()
        mockModel = MockTransactionsInfoModel()
        mockRouter = MockRouterTransactionsInfo()
        
        stubTransactions = createStubTransactions()
        stubTotalInGBP = 1000.0
        stubSKU = "Foo"
        
        sut = TransactionsInfoPresenter(model: mockModel, router: mockRouter, sku: stubSKU)
        sut.view = mockView
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
