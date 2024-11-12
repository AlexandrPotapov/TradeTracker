//
//  TransactionsInfoViewControllerTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 09.11.2024.
//

import XCTest
@testable import TradeTracker

final class TransactionsInfoViewControllerTests: XCTestCase {
    var mockPresenter: MockTransactionsInfoPresenter!
    var sut: TransactionsInfoViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockPresenter = MockTransactionsInfoPresenter()
        sut = TransactionsInfoViewController()
        
        mockPresenter.title = "Foo"
        sut.presenter = mockPresenter
    }
    
    override func tearDownWithError() throws {
        mockPresenter = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testViewDidLoadCallsed() {
        sut.viewDidLoad()
        XCTAssertTrue(mockPresenter.didCallViewDidLoad)
    }
    
    func testViewDidLoadSetDesiredTitle() {
        sut.viewDidLoad()
        XCTAssertEqual(sut.navigationItem.title, "Foo")
    }
}
