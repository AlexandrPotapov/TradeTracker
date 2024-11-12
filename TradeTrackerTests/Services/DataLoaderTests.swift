//
//  DataLoaderTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 12.11.2024.
//

import XCTest
@testable import TradeTracker

final class DataLoaderTests: XCTestCase {
    var sut: DataLoader!
    var testBundle: Bundle!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DataLoader()
        testBundle = Bundle(for: type(of: self)) // Используем бандл для загрузки тестовых файлов
    }
    
    override func tearDownWithError() throws {
        sut = nil
        testBundle = nil
        try super.tearDownWithError()
    }

    func testLoad_Success() {
        // Arrange
        guard let url = testBundle.url(forResource: "TestData", withExtension: "plist") else {
            XCTFail("Missing file: TestData.plist")
            return
        }
        
        // Act
        let result: Result<[TestData], DataServiceError> = sut.load(from: url, as: [TestData].self)
        
        // Assert
        switch result {
        case .success(let data):
            XCTAssertEqual(data.count, 2, "Expected 2 items but got \(data.count)")
            XCTAssertEqual(data.first?.name, "Test Name 1", "Expected name 'Test Name 1' but got \(data.first?.name ?? "")")
        case .failure(let error):
            XCTFail("Expected success but got failure with error: \(error)")
        }
    }

    func testLoad_FileNotFound() {
        // Arrange
        let invalidURL = URL(fileURLWithPath: "/path/to/invalid/file.plist")
        
        // Act
        let result: Result<[TestData], DataServiceError> = sut.load(from: invalidURL, as: [TestData].self)
        
        // Assert
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            if case .dataLoadingFailed(let underlyingError) = error {
                XCTAssertNotNil(underlyingError, "Expected an underlying error for missing file")
            } else {
                XCTFail("Expected dataLoadingFailed error but got \(error)")
            }
        }
    }

    func testLoad_InvalidDataFormat() {
        // Arrange
        guard let url = testBundle.url(forResource: "InvalidData", withExtension: "plist") else {
            XCTFail("Missing file: InvalidData.plist")
            return
        }
        
        // Act
        let result: Result<[TestData], DataServiceError> = sut.load(from: url, as: [TestData].self)
        
        // Assert
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            if case .dataLoadingFailed(let underlyingError) = error {
                XCTAssertNotNil(underlyingError, "Expected an underlying error for invalid data")
            } else {
                XCTFail("Expected dataLoadingFailed error but got \(error)")
            }
        }
    }
}

// MARK: - Вспомогательные модели

struct TestData: Decodable {
    let name: String
    let value: Int
}
