//
//  HoldingViewControllerTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 14.11.2024.
//

import XCTest
@testable import TradeTracker

final class HoldingViewControllerTests: XCTestCase {

    var sut: HoldingViewController!
    var mockDelegate: MockHoldingDelegate!
    var spyAlertController: UIViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        spyAlertController = UIViewController()
        mockDelegate = MockHoldingDelegate()
        sut = HoldingViewController(withAlertController: spyAlertController)
        sut.delegate = mockDelegate
    }

    override func tearDownWithError() throws {
        sut = nil
        mockDelegate = nil
        spyAlertController = nil
        try super.tearDownWithError()
    }

    func testViewDidAppear_PresentsAlertController() {
        
        // Arrange
        // Настраиваем окно для отображения HoldingViewController
        let spyWindow = UIWindow()
        spyWindow.rootViewController = sut
        spyWindow.makeKeyAndVisible()

        // Act - Триггерим метод viewDidAppear для отображения alertController
        sut.viewDidAppear(false)
        
        // Assert
        XCTAssertEqual(sut.presentedViewController, spyAlertController, "Presented alert controller should match the expected alert.")
    }
    

    func testDismiss_CallsDelegateOnAlertDismissal() {
        // Arrange
        let expectation = expectation(description: "Delegate method is called upon alert dismissal")

        mockDelegate.didDismissAlertHandler = { viewController, alert in
            XCTAssertEqual(viewController as? HoldingViewController, self.sut, "Delegate should be called with correct HoldingViewController.")
            XCTAssertEqual(alert, self.spyAlertController, "Delegate should be called with the correct alert controller.")
            expectation.fulfill()
        }

        // Act
        sut.dismiss(animated: false)

        // Assert
        wait(for: [expectation], timeout: 1.0)
    }
//    // или можно было сделать так:
//    func testDismiss_CallsDelegateOnAlertDismissal() {
//
//        // Act
//        sut.dismiss(animated: false)
//        
//        // Assert
//        XCTAssertEqual(sut, mockDelegate.missVC as? HoldingViewController, "Delegate should be called.")
//        XCTAssertEqual(sut.testAlertController, spyAlertController, "Delegate should be called.")
//
//    }
    
    // MARK: - Edge cases
    
    func testMultipleDismisses_CallsDelegateOnEachDismissal() {
        // Arrange
        let expectation = expectation(description: "Delegate method is called upon alert dismissal")
        var dismissCount = 0
        
        mockDelegate.didDismissAlertHandler = { viewController, alert in
            dismissCount += 1
            XCTAssertEqual(viewController as? HoldingViewController, self.sut, "Delegate should be called with correct HoldingViewController.")
            XCTAssertEqual(alert, self.spyAlertController, "Delegate should be called with the correct alert controller.")
            
            // Fulfill the expectation once, we only need to wait for the first dismissal.
            if dismissCount == 2 {
                XCTAssertEqual(viewController as? HoldingViewController, self.sut, "Delegate should be called with correct HoldingViewController.")
                XCTAssertEqual(alert, self.spyAlertController, "Delegate should be called with the correct alert controller.")
                expectation.fulfill()
            }
        }

        // Act
        sut.dismiss(animated: false)
        sut.dismiss(animated: false)
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(dismissCount, 2, "Delegate should be called twice for two dismissals.")
    }
    
    
}

// MARK: - Mock Delegate

final class MockHoldingDelegate: HoldingDelegate {

    var didDismissAlertHandler: ((AlertHoldingViewProtocol, UIViewController) -> Void)?

    func viewController(_ viewController: AlertHoldingViewProtocol, didDismissAlert alertController: UIViewController) {
        didDismissAlertHandler?(viewController, alertController)
    }
}
