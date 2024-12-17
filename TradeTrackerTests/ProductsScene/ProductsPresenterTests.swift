//
//  PresenterProductsTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 04.11.2024.
//

import XCTest
@testable import TradeTracker
import Features


final class ProductsPresenterTests: XCTestCase {
    
    var mockView: ProductsViewMock!
    var mockModel: ProductsModelStub!
    var mockRouter: ProductsRouterMock!
    var sut: ProductsPresenter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockView = ProductsViewMock()
        mockModel = ProductsModelStub()
        mockRouter = ProductsRouterMock()
        sut = ProductsPresenter(model: mockModel, router: mockRouter)
        sut.view = mockView
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
        for (i, viewModel) in mockView.viewModels!.enumerated() {
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

    //stub
    private func getProducts() -> [Product] {
        [Product(sku: "Foo", transactionCount: 1),
         Product(sku: "Bar", transactionCount: 2),
         Product(sku: "Baz", transactionCount: 3)]
    }
}
