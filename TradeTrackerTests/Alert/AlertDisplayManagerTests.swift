//
//  AlertDisplayManagerTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 14.11.2024.
//

import XCTest
@testable import TradeTracker

final class AlertDisplayManagerTests: XCTestCase {
    var mockAlertWindow: MockAlertWindow!
    var mockAlertPresenterFactory: MockAlertPresenterFactory!
    var mockAlertQueueManager: MockAlertQueueManager!
    var sut: AlertDisplayManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAlertWindow = MockAlertWindow()
        mockAlertPresenterFactory = MockAlertPresenterFactory(mckAlertWindow: mockAlertWindow)
        mockAlertQueueManager = MockAlertQueueManager()
        
        sut = AlertDisplayManager(alertPresenterFactory: mockAlertPresenterFactory)
        sut.alertQueueManager = mockAlertQueueManager
    }
    
    override func tearDownWithError() throws {
        mockAlertWindow = nil
        mockAlertPresenterFactory = nil
        mockAlertQueueManager = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testShowNextAlertIfPresent_SetsDesiredAlertWindow() {
        // Arrange
        let testAlert = UIViewController()
        mockAlertQueueManager.enqueueAlert(testAlert)
        
        // Act
        sut.showNextAlertIfPresent()
        
        // Assert
        XCTAssertEqual(mockAlertWindow.capturedAlert, testAlert, "AlertDisplayManager should display the correct alert.")
    }
    
    func testShowNextAlertIfPresent_DoesNotShowAlertWhenWindowIsOccupied() {
        // Arrange
        sut.testAlertWindow = mockAlertWindow
        let testAlert = UIViewController()
        mockAlertQueueManager.enqueueAlert(testAlert)

        // Act
        sut.showNextAlertIfPresent()
        
        // Assert
        XCTAssertNil(mockAlertWindow.capturedAlert, "AlertDisplayManager should not display an alert when an alert window is already occupied.")
    }
//    
    func testAlertWindowDidDismissAlert_ShowsNextAlertWhenAvailable() {
        // Arrange
        let firstAlert = UIViewController()
        let secondAlert = UIViewController()
        mockAlertQueueManager.enqueueAlert(firstAlert)
        mockAlertQueueManager.enqueueAlert(secondAlert)


        sut.showNextAlertIfPresent()
        XCTAssertEqual(mockAlertWindow.capturedAlert, firstAlert, "The first alert should be displayed.")
        
        // Act - имитируем закрытие первого алерта
        sut.alertWindow(mockAlertWindow, didDismissAlert: firstAlert)
        
        // Assert - проверяем что второй алерт показан
        XCTAssertEqual(mockAlertWindow.capturedAlert, secondAlert, "The second alert should be displayed after dismissing the first one.")
        XCTAssertNotNil(sut.alertWindow, "AlertDisplayManager should create a new alert window for the next alert.")
    }
    
    func testShowNextAlertIfPresent_DoesNotCreateWindowWhenQueueIsEmpty() {
        // Arrange - очередь пуста
        
        // Act
        sut.showNextAlertIfPresent()
        
        // Assert - окно не должно быть создано
        XCTAssertNil(sut.testAlertWindow, "AlertDisplayManager should not create an alert window if the queue is empty.")
    }

    func testShowNextAlertIfPresent_DoesNotShowAnotherAlertWhenOneIsAlreadyPresented() {
        // Arrange
        let firstAlert = UIViewController()
        mockAlertQueueManager.enqueueAlert(firstAlert)

        sut.showNextAlertIfPresent()
        XCTAssertEqual(mockAlertWindow.capturedAlert, firstAlert, "The first alert should be displayed.")
        
        // Act - пробуем показать второй алерт, пока есть первый
        let secondAlert = UIViewController()
        mockAlertQueueManager.enqueueAlert(secondAlert)
        sut.showNextAlertIfPresent()
        
        // Assert - Проверяем что отображается первый алерт, пока его не убрали, даже если есть второй алерт в очереди
        XCTAssertEqual(mockAlertWindow.capturedAlert, firstAlert, "A second alert should not be displayed if one is already being shown.")
    }

    func testAlertWindowDidDismissAlert_ClearsAlertWindowWhenQueueIsEmpty() {
        // Arrange
        let firstAlert = UIViewController()
        mockAlertQueueManager.enqueueAlert(firstAlert)

        // Act
        sut.showNextAlertIfPresent()
        XCTAssertEqual(mockAlertWindow.capturedAlert, firstAlert, "The first alert should be displayed.")
        
        // Assert - имитируем закрытие алерта
        sut.alertWindow(mockAlertWindow, didDismissAlert: firstAlert)
        
        // Assert - alertWindow должен быть очищен
        XCTAssertNil(sut.testAlertWindow, "AlertDisplayManager should clear the alert window if there are no more alerts in the queue.")
    }
}

// MARK: - Mock Objects

final class MockAlertWindow: AlertWindowProtocol {
    var capturedAlert: UIViewController?
    
    func presentAlert(_ alert: UIViewController) {
        capturedAlert = alert
    }
}

final class MockAlertPresenterFactory: AlertPresenterFactoryProtocol {
    var mckAlertWindow: MockAlertWindow
    
    init(mckAlertWindow: MockAlertWindow) {
        self.mckAlertWindow = mckAlertWindow
    }
    
    func makeAlertPresenter(delegate: AlertWindowDelegate) -> AlertWindowProtocol {
        return mckAlertWindow
    }
}

final class MockAlertQueueManager: AlertQueueManagerProtocol {
    var alertsQueue = Queue<UIViewController>()
    
    var alertQueueCount: Int {
        return alertsQueue.count
    }
    
    var calledDequeueAlert = false

    
    func enqueueAlert(_ alertController: UIViewController) {
        alertsQueue.enqueue(alertController)
    }
    
    func dequeueAlert() -> UIViewController? {
        calledDequeueAlert = true
        return alertsQueue.dequeue()
    }
    
}
