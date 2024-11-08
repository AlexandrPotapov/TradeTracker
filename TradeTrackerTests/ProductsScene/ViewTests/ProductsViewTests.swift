//
//  ProductsViewTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 07.11.2024.
//

import XCTest
@testable import TradeTracker

final class ProductsViewTests: XCTestCase {
    
    var view: ProductsView!
    var mockPresenter: MockProductsPresenter!
    
    override func setUp() {
        super.setUp()
        
        // Создаем мок для презентера
        mockPresenter = MockProductsPresenter()
        
        // Создаем ProductsViewController и передаем мок-презентер
        view = ProductsView()
        view.presenter = mockPresenter
    }

    func testCustomViewSuccessUpdatesViewModels() {
        // Создаем несколько viewModels
        let viewModels = [
            ProductViewModel(sku: "SKU001", transactionCount: "1"),
            ProductViewModel(sku: "SKU002", transactionCount: "2"),
            ProductViewModel(sku: "SKU003", transactionCount: "3")
        ]
        
        // Вызываем success для обновления данных
        view.success(viewModels: viewModels)
        
        // Проверяем, что customView обновил данные
                XCTAssertEqual(view.viewModels.count, 3)
                XCTAssertEqual(view.testTableView.numberOfRows(inSection: 0), 3)
    }
    
    func testDidSelectRowCallsPresenter() {
        view.presenter?.tapOnTheProduct(with: "Foo")
        
        XCTAssertTrue(mockPresenter.didCallTapOnTheProduct)
        XCTAssertEqual(mockPresenter.capturedProductSku, "Foo")
    }
}
