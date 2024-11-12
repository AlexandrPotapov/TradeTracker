//
//  BuilderTransactionInfoTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 12.11.2024.
//

import XCTest
@testable import TradeTracker

final class BuilderTransactionInfoTests: XCTestCase {
    
    func testBuildProduct_CreatesCorrectViewController() throws {
        // Arrange
        let dataManager = MockDataManagerWithRates()
        let sut = TransactionInfoBuilder(dataManager: dataManager)
        let sku = "Foo"
        
        // Act
        let viewController = sut.buildTransactionsInfo(with: sku)
        
        // Assert
        XCTAssertTrue(viewController is TransactionsInfoViewController,
            "Expected ProductsViewController, but got \(type(of: viewController))")
        
        if let transactionsInfoVC = viewController as? TransactionsInfoViewController {
            XCTAssertNotNil(transactionsInfoVC.presenter, "TransactionsInfoViewController should have a presenter")
            
            XCTAssertTrue(transactionsInfoVC.presenter is TransactionsInfoPresenter,
                "Expected TransactionsInfoPresenter, but got \(type(of: transactionsInfoVC.presenter!))")
            
            let presenter = transactionsInfoVC.presenter as? TransactionsInfoPresenter
            XCTAssertNotNil(presenter?.view, "Presenter should have a view")
        }
    }
}

