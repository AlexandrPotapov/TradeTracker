//
//  ProductsBuilderTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 07.11.2024.
//

import XCTest
@testable import TradeTracker

final class ProductsBuilderTests: XCTestCase {
    
    func testBuildProductCreatesCorrectViewController() throws {
        // Arrange
        let builder = ProductsBuilder()
        
        // Act
        let viewController = builder.buildProduct()
        
        // Assert
        XCTAssertTrue(viewController is ProductsViewController, "Expected ProductsViewController, but got \(type(of: viewController))")
        
        guard let productsVC = viewController as? ProductsViewController else {
            XCTFail("Failed to cast to ProductsViewController")
            return
        }
        
        XCTAssertNotNil(productsVC.presenter, "Expected ProductsViewController to have a presenter")
        XCTAssertTrue(productsVC.presenter is ProductsPresenter, "Expected ProductsPresenter, but got \(type(of: productsVC.presenter))")
        
        let presenter = productsVC.presenter as? ProductsPresenter
        XCTAssertNotNil(presenter?.view, "Expected presenter to have a view")
    }
}
