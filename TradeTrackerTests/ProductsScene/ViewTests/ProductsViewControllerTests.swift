//
//  ProductsViewControllerTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 07.11.2024.
//

import XCTest
@testable import TradeTracker

final class ProductsViewControllerTests: XCTestCase {
    
    var mockPresenter: MockProductsPresenter!
    var sut: ProductsViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockPresenter = MockProductsPresenter()
        sut = ProductsViewController()
        sut.presenter = mockPresenter
    }
    
    override func tearDownWithError() throws {
        mockPresenter = nil
        sut = nil
        try super.setUpWithError()
    }

    func testViewDidLoad_callsPresenterViewDidLoad() {
        // Вызываем viewDidLoad для viewController
        sut.viewDidLoad()
        
        // Проверяем, что метод viewDidLoad в презентере был вызван
        XCTAssertTrue(mockPresenter.didCallViewDidLoad)
    }
}

// MARK: - Mock Objects

final class MockProductsPresenter: ProductsPresenterProtocol {
    
    var didCallViewDidLoad = false
    var capturedProductSku: String?
    
    func viewDidLoad() {
        didCallViewDidLoad = true
    }
    
    func tapOnTheProduct(with sku: String) {
        capturedProductSku = sku
    }
}
