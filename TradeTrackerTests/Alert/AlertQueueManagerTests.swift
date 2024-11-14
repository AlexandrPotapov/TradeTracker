//
//  AlertQueueManagerTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 14.11.2024.
//

import XCTest
@testable import TradeTracker

final class AlertQueueManagerTests: XCTestCase {
    
    var sut: AlertQueueManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AlertQueueManager()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testEnqueueAlert_AddsAlertToQueue() {
        // Arrange
        let alertController = UIViewController()
        
        // Act
        sut.enqueueAlert(alertController)
        
        // Assert
        XCTAssertEqual(sut.dequeueAlert(), alertController, "Enqueued alert should be the first to dequeue.")
    }
    
    func testDequeueAlert_ReturnsAlertsInFIFOOrder() {
        // Arrange
        let firstAlert = UIViewController()
        let secondAlert = UIViewController()
        
        // Act
        sut.enqueueAlert(firstAlert)
        sut.enqueueAlert(secondAlert)
        
        // Assert
        XCTAssertEqual(sut.dequeueAlert(), firstAlert, "The first enqueued alert should be dequeued first.")
        XCTAssertEqual(sut.dequeueAlert(), secondAlert, "The second enqueued alert should be dequeued next.")
    }
    
    func testDequeueAlert_ReturnsNilWhenQueueIsEmpty() {
        // Act
        let result = sut.dequeueAlert()
        
        // Assert
        XCTAssertNil(result, "Dequeueing from an empty queue should return nil.")
    }
    
    func testEnqueueMultipleAlerts_AndDequeueAll() {
        // Arrange
        let alerts = [UIViewController(), UIViewController(), UIViewController()]
        
        // Act
        alerts.forEach { sut.enqueueAlert($0) }
        
        // Assert
        alerts.forEach {
            XCTAssertEqual(sut.dequeueAlert(), $0, "Each dequeue should return alerts in the order they were enqueued.")
        }
        XCTAssertNil(sut.dequeueAlert(), "Queue should be empty after all alerts are dequeued.")
    }
}
