//
//  AlertWindowTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 15.11.2024.
//

import XCTest
@testable import TradeTracker

class AlertWindowTests: XCTestCase {

    var sut: AlertWindow!
    var mockDelegate: MockAlertWindowDelegate!
    var spyAlertController: UIViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockDelegate = MockAlertWindowDelegate()
        spyAlertController = UIViewController()
        sut = AlertWindow(delegate: mockDelegate)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockDelegate = nil
        spyAlertController = nil
        try super.tearDownWithError()
    }

    func testPresentAlert_PresentsAlertController() {
        // Act
        sut.presentAlert(spyAlertController)
        
        // Assert
        XCTAssertTrue(sut.rootViewController is HoldingViewController, "Root view controller should be of type HoldingViewController.")
        let holdingViewController = sut.rootViewController as? HoldingViewController
        holdingViewController!.viewDidAppear(false)

        XCTAssertEqual(holdingViewController?.presentedViewController, spyAlertController, "The presented alert controller should match the expected alert.")
    }
    
    func testDelegateCalled_WhenAlertDismissed() {
        // Arrange
        let expectation = expectation(description: "Delegate method is called upon alert dismissal")
        
        mockDelegate.didDismissAlertHandler = { alertWindow, alert in
            XCTAssertEqual(alertWindow as? AlertWindow, self.sut, "Delegate should be called with the correct AlertWindow.")
            XCTAssertEqual(alert, self.spyAlertController, "Delegate should be called with the correct alert controller.")
            expectation.fulfill()
        }

        // Act
        sut.presentAlert(spyAlertController)
        let holdingViewController = sut.rootViewController as? HoldingViewController
        holdingViewController?.dismiss(animated: false)
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testResignKeyAndHide_HidesAlertWindow() {
        // Arrange
        sut.presentAlert(spyAlertController)
        
        // Act
        let holdingViewController = sut.rootViewController as? HoldingViewController
        holdingViewController?.dismiss(animated: false)
        
        // Assert
        XCTAssertTrue(sut.isHidden, "The AlertWindow should be hidden after the alert is dismissed.")
        XCTAssertFalse(sut.isKeyWindow, "The AlertWindow should not be the key window after dismissal.")
    }
    
    func testDelegateCalled_WhenAlertIsPresented() {
        // Arrange
        let expectation = expectation(description: "Delegate method is called when alert is presented")
        
        mockDelegate.didDismissAlertHandler = { alertWindow, alert in
            XCTAssertEqual(alertWindow as? AlertWindow, self.sut, "Delegate should be called with the correct AlertWindow.")
            XCTAssertEqual(alert, self.spyAlertController, "Delegate should be called with the correct alert controller.")
            expectation.fulfill()
        }

        // Act
        sut.presentAlert(spyAlertController)
        let holdingViewController = sut.rootViewController as? HoldingViewController
        holdingViewController?.dismiss(animated: false)
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - MockAlertWindowDelegate

class MockAlertWindowDelegate: AlertWindowDelegate {

    var didDismissAlertHandler: ((AlertWindowProtocol, UIViewController) -> Void)?
    
    func alertWindow(_ alertWindow: AlertWindowProtocol, didDismissAlert alertController: UIViewController) {
        didDismissAlertHandler?(alertWindow, alertController)
    }
}
