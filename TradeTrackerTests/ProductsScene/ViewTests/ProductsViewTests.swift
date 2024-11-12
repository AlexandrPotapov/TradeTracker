//
//  ProductsViewTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 07.11.2024.
//

import XCTest
@testable import TradeTracker

final class ProductsViewTests: XCTestCase {
    
    var mockPresenter: MockProductsPresenter!
    var stubViewModels: [ProductViewModel]!
    var sut: ProductsView!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockPresenter = MockProductsPresenter()
        stubViewModels = setViewModels()
        
        sut = ProductsView()
        sut.presenter = mockPresenter
    }
    
    override func tearDownWithError() throws {
        mockPresenter = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testSuccess_UpdatesViewModels() {
        
        // Act
        sut.success(viewModels: stubViewModels)
        
        // Assert
        XCTAssertEqual(sut.viewModels.count, 3)
        XCTAssertEqual(sut.testTableView.numberOfRows(inSection: 0), 3)
    }
    
    func testDidSelectRowAt_CallsPresenter() {
        
        // Arrange
        sut.success(viewModels: stubViewModels)
        
        // Act
        sut.tableView(sut.testTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        // Assert
        XCTAssertEqual(mockPresenter.capturedProductSku, "SKU001",
                       "Expected SKU001 but got \(mockPresenter.capturedProductSku ?? "nil")")
    }
    
// MARK: - Helpers
    private func setViewModels() -> [ProductViewModel]{
        [
            ProductViewModel(sku: "SKU001", transactionCount: "1"),
            ProductViewModel(sku: "SKU002", transactionCount: "2"),
            ProductViewModel(sku: "SKU003", transactionCount: "3")
        ]
    }
}
