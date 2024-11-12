//
//  BuilderProductsTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 07.11.2024.
//

import XCTest
@testable import TradeTracker

final class BuilderProductsTests: XCTestCase {
    
    func testBuildProduct_CreatesCorrectViewController() throws {
        // Arrange
        let sut = ProductsBuilder()
        
        // Act
        let viewController = sut.buildProduct()
        
        // Assert
        XCTAssertTrue(viewController is ProductsViewController,
            "Expected ProductsViewController, but got \(type(of: viewController))")
        
        if let productsVC = viewController as? ProductsViewController {
            XCTAssertNotNil(productsVC.presenter, "ProductsViewController should have a presenter")
            
            XCTAssertTrue(productsVC.presenter is ProductsPresenter,
                "Expected ProductsPresenter, but got \(type(of: productsVC.presenter!))")
            
            let presenter = productsVC.presenter as? ProductsPresenter
            XCTAssertNotNil(presenter?.view, "Presenter should have a view")
        }
    }
}
