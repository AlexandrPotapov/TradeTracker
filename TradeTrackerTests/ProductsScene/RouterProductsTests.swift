//
//  RouterProductsTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 05.11.2024.
//

import XCTest
@testable import TradeTracker

final class RouterProductsTests: XCTestCase {
    var mockTransactionInfoBuilder: MockTransactionInfoBuilder!
    var mockAlertBuilder: MockAlertBuilder!
    var mockRootViewController: MockViewController!
    var mockNavigationController: MockNavigationController!
    var router: RouterProducts!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockTransactionInfoBuilder = MockTransactionInfoBuilder()
        mockAlertBuilder = MockAlertBuilder()
        mockRootViewController = MockViewController()
        mockNavigationController = MockNavigationController(rootViewController: mockRootViewController)
        
        router = RouterProducts(
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

// MARK: - Mock Objects

final class MockTransactionInfoBuilder: TransactionInfoBuilderProtocol {
    var capturedProductSku: String?

    func buildTransactionsInfo(with sku: String) -> UIViewController {
        capturedProductSku = sku
        return UIViewController()
    }
}

final class MockAlertBuilder: AlertBuilderProtocol {
    var capturedTitle: String?
    var capturedMessage: String?

    func buildAlert(title: String, message: String) -> UIViewController {
        capturedTitle = title
        capturedMessage = message
        return UIViewController()
    }
}

final class MockNavigationController: UINavigationController {
    
    var presentedVC: UIViewController?
    var rootViewController: UIViewController?
    
    override init(rootViewController: UIViewController) {
         super.init(nibName: nil, bundle: nil)
         self.viewControllers = [rootViewController]
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }

}

final class MockViewController: UIViewController {
    var presentedVC: UIViewController?

    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        
        presentedVC = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
