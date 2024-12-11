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
    var mockDelegate: AlertWindowDelegateMock!
    var spyAlertController: UIViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockDelegate = AlertWindowDelegateMock()
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
//        Классификация: Test Spy (тестовый шпион)
        //Хотя объект UIViewController сам по себе не фиксирует вызовы, вы используете его в тестах как объект, поведение которого наблюдаете.
//        Пример использования: В тесте testPresentAlert_PresentsAlertController, вы проверяете, что spyAlertController действительно был представлен через sut.
        sut.presentAlert(spyAlertController)
        
        //Почему это test spy?
//        Spy — это объект, который помогает отслеживать вызовы его методов или свойства, а также фиксировать, какие данные были переданы или какие методы были вызваны.
//        В вашем случае, spyAlertController — это просто экземпляр UIViewController, который вы используете для проверки того, был ли он представлен через метод presentAlert:
        
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

// MARK: - AlertWindowTests
class AlertWindowDelegateMock: AlertWindowDelegate {

    var didDismissAlertHandler: ((AlertWindowProtocol, UIViewController) -> Void)?
    
    func alertWindow(_ alertWindow: AlertWindowProtocol, didDismissAlert alertController: UIViewController) {
        didDismissAlertHandler?(alertWindow, alertController)
    }
}
