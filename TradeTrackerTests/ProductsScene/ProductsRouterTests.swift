//
//  RouterProductsTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 05.11.2024.
//

import XCTest
@testable import TradeTracker

final class ProductsRouterTests: XCTestCase {
    var mockTransactionInfoBuilder: TransactionInfoBuilderMock!
    var mockAlertBuilder: AlertBuilderMock!
    var mockRootViewController: ViewControllerMock!
    var mockNavigationController: NavigationControllerMock!
    var router: ProductsRouter!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockTransactionInfoBuilder = TransactionInfoBuilderMock()
        mockAlertBuilder = AlertBuilderMock()
        mockRootViewController = ViewControllerMock()
        mockNavigationController = NavigationControllerMock(rootViewController: mockRootViewController)
        
        router = ProductsRouter(
            transactionsInfoBuilder: mockTransactionInfoBuilder,
            alertBuilder: mockAlertBuilder
        )
        router.setRootViewController(root: mockRootViewController)
    }

    override func tearDownWithError() throws {
        mockTransactionInfoBuilder = nil
        mockAlertBuilder = nil
        mockNavigationController = nil
        router = nil
        try super.tearDownWithError()
    }

    func testShowTransactionsInfo_SetsDesiredSKU() {
        
        // Arrange
        let product = ProductViewModel(sku: "Foo", transactionCount: "Bar")
        
        // Act
        router.showTransactionsInfo(with: product.sku)
        
        // Assert
        XCTAssertEqual(mockTransactionInfoBuilder.capturedProductSku, product.sku,
                       "The correct product SKU should be passed to buildTransactionsInfo")
    }

    func testShowTransactionsInfo_PushesViewController() {
        
        // Arrange
        let product = ProductViewModel(sku: "Foo", transactionCount: "Bar")
        
        // Act
        router.showTransactionsInfo(with: product.sku)

        // Assert
        XCTAssertNotNil(mockNavigationController.presentedVC,
                        "Should present a view controller")
    }

    func testShowAlert_SetsDesiredTitleAndMessage() {
        
        // Arrange
        let title = "Foo"
        let message = "Bar"
        
        // Act
        router.showAlert(title: title, message: message)

        // Assert
        XCTAssertEqual(mockAlertBuilder.capturedTitle, title,
                       "Should pass the correct title to buildAlert")
        
        XCTAssertEqual(mockAlertBuilder.capturedMessage, message,
                       "Should pass the correct message to buildAlert")
    }

    func testShowAlert_PresentsAlertController() {
        
        // Arrange
        let title = "Foo"
        let message = "Bar"
        
        // Act
        router.showAlert(title: title, message: message)
        
        // Assert†
        XCTAssertNotNil(mockRootViewController.presentedVC,
                        "Should present a view controller")
    }
}
