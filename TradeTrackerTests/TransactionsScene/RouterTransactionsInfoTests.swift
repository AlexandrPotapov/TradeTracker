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
    var mockAlertDisplayManager: MockAlertDisplayManager!
    var mockAlertQueueManager: MockAlertQueueManager!

    var sut: RouterTransactionInfo!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAlertBuilder = MockAlertBuilder()
        mockAlertDisplayManager = MockAlertDisplayManager()
        mockAlertQueueManager = MockAlertQueueManager()
        
        sut = RouterTransactionInfo(alertQueueManager: mockAlertQueueManager, alertDisplayManager: mockAlertDisplayManager, alertBuilder: mockAlertBuilder)
    }

    override func tearDownWithError() throws {
        mockAlertBuilder = nil
        mockAlertDisplayManager = nil
        mockAlertQueueManager = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testShowAlert_SetsDesiredTitleAndMessage() {
        
        // Arrange
        let title = "Foo"
        let message = "Bar"
        
        // Act
        sut.showAlert(title: title, message: message)

        // Assert
        XCTAssertEqual(mockAlertBuilder.capturedTitle, title,
                       "Should pass the correct title to buildAlert")
        
        XCTAssertEqual(mockAlertBuilder.capturedMessage, message,
                       "Should pass the correct message to buildAlert")
    }

    func testShowAlert_Calls_ShowNextAlertIfPresent() {
        
        // Arrange
        let title = "Foo"
        let message = "Bar"
        
        // Act
        sut.showAlert(title: title, message: message)
        
        // Assert
        XCTAssertTrue(mockAlertDisplayManager.showNextAlertIsTrue,
                      "Should call showNextAlertIfPresent")
    }
    
    func testShowAlert_AddedAlertInQueue() {
        
        // Arrange
        let title = "Foo"
        let message = "Bar"
        
        // Act
        sut.showAlert(title: title, message: message)
        
        sut.showAlert(title: title, message: message)

        
        // Assert
        XCTAssertEqual(mockAlertQueueManager.alertQueueCount, 2,
                      "Expected 2 alert in queue, but got \(mockAlertQueueManager.alertQueueCount)")
    }
}



// MARK: - Mock Objects
final class MockAlertDisplayManager: AlertDisplayManagerProtocol {
    
    var showNextAlertIsTrue = false
    
    func showNextAlertIfPresent() {
        showNextAlertIsTrue = true
    }
}
