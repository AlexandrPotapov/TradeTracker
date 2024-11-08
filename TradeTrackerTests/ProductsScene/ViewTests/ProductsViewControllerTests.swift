//
//  ProductsViewControllerTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 07.11.2024.
//

import XCTest
@testable import TradeTracker

final class ProductsViewControllerTests: XCTestCase {
    
    var viewController: ProductsViewController!
    var mockPresenter: MockProductsPresenter!
    
    override func setUp() {
        super.setUp()
        
        // Создаем мок для презентера
        mockPresenter = MockProductsPresenter()
        
        // Создаем ProductsViewController и передаем мок-презентер
        viewController = ProductsViewController()
        viewController.presenter = mockPresenter
    }

    func testViewDidLoad_callsPresenterViewDidLoad() {
        // Вызываем viewDidLoad для viewController
        viewController.viewDidLoad()
        
        // Проверяем, что метод viewDidLoad в презентере был вызван
        XCTAssertTrue(mockPresenter.didCallViewDidLoad)
    }
    
    func testDidSelectRowCallsPresenter() {
        viewController.presenter?.tapOnTheProduct(with: "Foo")
        
        XCTAssertTrue(mockPresenter.didCallTapOnTheProduct)
        XCTAssertEqual(mockPresenter.capturedProductSku, "Foo")
    }
}

// MARK: - Mock Objects

final class MockProductsPresenter: ProductsPresenterProtocol {
    
    var didCallViewDidLoad = false
    var didCallTapOnTheProduct = false
    var capturedProductSku: String?
    
    func viewDidLoad() {
        didCallViewDidLoad = true
    }
    
    func tapOnTheProduct(with sku: String) {
        didCallTapOnTheProduct = true
        capturedProductSku = sku
    }
}
