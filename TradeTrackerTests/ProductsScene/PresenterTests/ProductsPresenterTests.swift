//
//  ProductsSceneTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 04.11.2024.
//

import XCTest
@testable import TradeTracker

final class ProductsPresenterTests: XCTestCase {
    
    var mockView: MockProductsView!
    var presenter: ProductsPresenterProtocol!
    var mockModel: MockProductsModel!
    var mockRouter: MockRouter!

    override func setUpWithError() throws {
        
        mockView = MockProductsView()
        mockRouter = MockRouter()
        mockModel = MockProductsModel()
        presenter = ProductsPresenter(view: mockView, model: mockModel, router: mockRouter)
    }

    override func tearDownWithError() throws {
        mockView = nil
        mockModel = nil
        presenter = nil
        mockRouter = nil
    }


    func testViewDidLoadSuccess() throws {
        mockModel.result = .success([ProductViewModel(sku: "Foo", transactionCount: "Baz")])
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockView.successCalled)
        XCTAssertEqual(mockView.viewModels.first?.sku, "Foo")
    }

    func testViewDidLoadFailure() throws {
        mockModel.result = .failure(.resourceNotFound(name: "Foo"))
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockRouter.alertShown)
        XCTAssertEqual(mockRouter.alertMessage, "Resource not found: Foo")
    }

    func testTapOnTheProduct() throws {
        let product = ProductViewModel(sku: "Foo", transactionCount: "Baz")
        presenter.tapOnTheProduct(with: product.sku)
        
        XCTAssertTrue(mockRouter.showTransactionsInfoCalled)
        XCTAssertEqual(mockRouter.capturedProductSku, "Foo")

    }

}

// MARK: - Mock Objects

final class MockProductsView: ProductsViewProtocol {
    var successCalled = false
    var viewModels: [ProductViewModel] = []

    func success(viewModels: [ProductViewModel]) {
        successCalled = true
        self.viewModels = viewModels
    }
}

final class MockProductsModel: ProductsModelProtocol {
    var result: Result<[ProductViewModel], DataServiceError>?

    func getProductsInfo() -> Result<[ProductViewModel], DataServiceError> {
        return result ?? .failure(.resourceNotFound(name: "Mock"))
    }
}

final class MockRouter: RouterProductsProtocol {
    
    var showTransactionsInfoCalled = false
    var rootVCSetCalled = false
    var alertShown = false
    var alertMessage: String?
    var capturedProductSku: String?


    func showTransactionsInfo(with sku: String) {
        showTransactionsInfoCalled = true
        capturedProductSku = sku
    }
    
    func setRootViewController(root: UIViewController) { }

    func showAlert(title: String, message: String) {
        alertShown = true
        alertMessage = message
    }
}
