//
//  RouterTransactionsInfoTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 12.11.2024.
//


import XCTest
@testable import TradeTracker

final class RouterTransactionsInfoTests: XCTestCase {
    var mockAlertBuilder: MockAlertBuilder!
    var mockRootViewController: MockViewController!
    var mockNnavigationController: MockNavigationController!
    var router: RouterTransactionInfo!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAlertBuilder = MockAlertBuilder()
        mockRootViewController = MockViewController()
        mockNnavigationController = MockNavigationController(rootViewController: mockRootViewController)
        
        router = RouterTransactionInfo(alertBuilder: mockAlertBuilder)
        router.setRootViewController(root: mockRootViewController)
    }

    override func tearDownWithError() throws {
        mockAlertBuilder = nil
        mockNnavigationController = nil
        router = nil
        try super.tearDownWithError()
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
        
        // Assert
        XCTAssertNotNil(mockRootViewController.presentedVC,
                        "Should present a view controller")
    }
}
