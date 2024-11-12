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
    var mockModel: MockProductsModel!
    var mockRouter: MockRouter!
    var sut: ProductsPresenter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockView = MockProductsView()
        mockModel = MockProductsModel()
        mockRouter = MockRouter()
        sut = ProductsPresenter(view: mockView, model: mockModel, router: mockRouter)
    }

    override func tearDownWithError() throws {
        mockView = nil
        mockModel = nil
        mockRouter = nil
        sut = nil
        try super.tearDownWithError()
    }


    func testViewDidLoad_Success() throws {
        
        // Arrange
        let products = getProducts()
        mockModel.result = .success(products)
        
        // Act
        sut.viewDidLoad()
        
        // Assert
        for (i, viewModel) in mockView.viewModels.enumerated() {
            XCTAssertTrue(products.contains(where: { $0.sku == viewModel.sku}),
                          "Exptected \(products[i].sku), but got \(viewModel.sku)")
            
            XCTAssertTrue(products.contains(where: { String($0.transactionCount) == viewModel.transactionCount}),
                          "Exptected \(products[i].transactionCount), but got \(viewModel.transactionCount)")
        }
    }

    func testViewDidLoad_Failure() throws {
        
        // Arrange
        mockModel.result = .failure(.resourceNotFound(name: "Foo"))
        
        // Act
        sut.viewDidLoad()
        
        // Assert
        XCTAssertEqual(mockRouter.alertMessage,
                       "Resource not found: Foo",
                       "Expected \"Resource not found: Foo\", but got \"\(mockRouter.alertMessage ?? "nil")\"")
    }

    func testTapOnTheProduct_SetsDesiredSKU() throws {
        
        // Arrange
        let product = ProductViewModel(sku: "Foo", transactionCount: "1")
        
        // Act
        sut.tapOnTheProduct(with: product.sku)
        
        // Assert
        XCTAssertEqual(mockRouter.capturedProductSku, "Foo")

    }
    

    // MARK: - Helpers

    private func getProducts() -> [Product] {
        [Product(sku: "Foo", transactionCount: 1),
         Product(sku: "Bar", transactionCount: 2),
         Product(sku: "Baz", transactionCount: 3)]
    }
}

// MARK: - Mock Objects

final class MockProductsView: ProductsViewProtocol {
    var viewModels: [ProductViewModel] = []

    func success(viewModels: [ProductViewModel]) {
        self.viewModels = viewModels
    }
}

final class MockProductsModel: ProductsModelProtocol {
    var result: Result<[Product], DataServiceError>?

    func getProductsInfo() -> Result<[Product], DataServiceError> {
        return result ?? .failure(.resourceNotFound(name: "Mock"))
    }
}

final class MockRouter: RouterProductsProtocol {
    
    var alertMessage: String?
    var capturedProductSku: String?


    func showTransactionsInfo(with sku: String) {
        capturedProductSku = sku
    }
    
    func setRootViewController(root: UIViewController) { }

    func showAlert(title: String, message: String) {
        alertMessage = message
    }
}
