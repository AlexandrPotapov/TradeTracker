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
    var rootViewController: MockViewController!
    var navigationController: MockNavigationController!
    var router: RouterProducts!
    
    override func setUpWithError() throws {
        super.setUp()
        mockTransactionInfoBuilder = MockTransactionInfoBuilder()
        mockAlertBuilder = MockAlertBuilder()
        rootViewController = MockViewController()
        
        navigationController = MockNavigationController(rootViewController: rootViewController)
        
        router = RouterProducts(
            transactionsInfoBuilder: mockTransactionInfoBuilder,
            alertBuilder: mockAlertBuilder
        )
        router.setRootViewController(root: rootViewController)
    }

    override func tearDownWithError() throws {
        router = nil
        mockTransactionInfoBuilder = nil
        mockAlertBuilder = nil
        navigationController = nil
        super.tearDown()
    }

    func testShowTransactionsInfoCallsBuildTransactionsInfo() {
        let product = ProductViewModel(sku: "Foo", transactionCount: "Baz")
        
        router.showTransactionsInfo(with: product.sku)

        XCTAssertTrue(mockTransactionInfoBuilder.didCallBuildTransactionsInfo, "Should call buildTransactionsInfo on transaction info builder")
        XCTAssertEqual(mockTransactionInfoBuilder.capturedProductSku, product.sku, "Should pass the correct product to buildTransactionsInfo")
    }

    func testShowTransactionsInfoPushesViewController() {
        let product = ProductViewModel(sku: "Foo", transactionCount: "Baz")
        
        router.showTransactionsInfo(with: product.sku)

        XCTAssertNotNil(navigationController.presentedVC, "Should present a view controller")
    }

    func testShowAlertCallsBuildAlert() {
        let title = "Foo"
        let message = "Baz"
        
        router.showAlert(title: title, message: message)

        XCTAssertTrue(mockAlertBuilder.didCallBuildAlert, "Should call buildAlert on alert builder")
        XCTAssertEqual(mockAlertBuilder.capturedTitle, title, "Should pass the correct title to buildAlert")
        XCTAssertEqual(mockAlertBuilder.capturedMessage, message, "Should pass the correct message to buildAlert")
    }

    func testShowAlertPresentsAlertController() {
        let title = "Foo"
        let message = "Baz"
        
        router.showAlert(title: title, message: message)
        
        XCTAssertNotNil(rootViewController.presentedVC, "Should present a view controller")
    }
}

// MARK: - Mock Objects

final class MockTransactionInfoBuilder: TransactionInfoBuilderProtocol {
    var didCallBuildTransactionsInfo = false
    var capturedProductSku: String?

    func buildTransactionsInfo(with sku: String) -> UIViewController {
        didCallBuildTransactionsInfo = true
        capturedProductSku = sku
        return UIViewController() // Возвращаем простой контроллер для теста
    }
}

final class MockAlertBuilder: AlertBuilderProtocol {
    var didCallBuildAlert = false
    var capturedTitle: String?
    var capturedMessage: String?

    func buildAlert(title: String, message: String) -> UIViewController {
        didCallBuildAlert = true
        capturedTitle = title
        capturedMessage = message
        return UIViewController() // Возвращаем простой контроллер для теста
    }
}

final class MockNavigationController: UINavigationController {
    
    var presentedVC: UIViewController?
    var rootViewController: UIViewController?
    // Инициализируем контроллер с заданным корневым контроллером
    override init(rootViewController: UIViewController) {
         super.init(nibName: nil, bundle: nil)
         self.viewControllers = [rootViewController]  // Устанавливаем корневой контроллер
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented") // Этот инициализатор не нужен для моков
     }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }

}

final class MockViewController: UIViewController {
    var presentedVC: UIViewController?

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedVC = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
