//
//  ConverterTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 12.11.2024.
//

import XCTest
@testable import TradeTracker

final class ConverterTests: XCTestCase {

    func testConvertToGBP_Success() {
        // Arrange
        let stubConversionRequest = ConversionRequest(amount: 100, fromCurrency: "USD", toCurrency: "GBP", rates: [Rate(from: "USD", to: "GBP", rate: 1.2)])
        let sut = Converter()

        // Act
        let result = sut.convertToGBP(request: stubConversionRequest)
        
        // Assert
        switch result {
        case .success(let conversionResponse):
            XCTAssertEqual(conversionResponse, 120.0, "Expected 120.0 but got \(conversionResponse)")
        case .failure:
            XCTFail("Expected .success but got .failure")
        }
    }
}
