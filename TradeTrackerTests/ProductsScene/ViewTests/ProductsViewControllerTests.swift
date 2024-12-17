//
//  ProductsViewControllerTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 07.11.2024.
//

import XCTest
@testable import TradeTracker
import Features


final class ProductsViewControllerTests: XCTestCase {
    
    var mockPresenter: ProductsPresenterMock!
    var sut: ProductsViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockPresenter = ProductsPresenterMock()
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
