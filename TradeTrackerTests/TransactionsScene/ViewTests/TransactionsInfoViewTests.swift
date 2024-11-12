//
//  TransactionsInfoViewTests.swift
//  TradeTrackerTests
//
//  Created by Alexander on 09.11.2024.
//

import XCTest
@testable import TradeTracker

final class TransactionsInfoViewTests: XCTestCase {
    var mockPresenter: MockTransactionsInfoPresenter!
    var sut: TransactionsInfoView!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockPresenter = MockTransactionsInfoPresenter()
        sut = TransactionsInfoView()
        mockPresenter.view = sut
    }
    
    override func tearDownWithError() throws {
        mockPresenter = nil
        sut = nil
        try super.setUpWithError()
    }
    
    func testViewDidLoadSetsDesiredHeader() {
        
        // Arrange
        mockPresenter.header = "Bar"
        sut.presenter = mockPresenter
        
        // Act
        sut.success(viewModels: createMockViewModels())
        
        // Assert
        XCTAssertEqual(mockPresenter.getHeader(),  sut.testableHeaderView.text)
        
    }
    
    func testTableViewNumberOfRowsMatchesViewModelCount() {
        // Arrange
        let viewModels = createMockViewModels()
        
        // Act
        sut.success(viewModels: viewModels)
        
        // Assert
        XCTAssertEqual(sut.testableTableView.numberOfRows(inSection: 0), viewModels.count)
    }
    
    func testCellForRowAtIndexPathReturnsConfiguredCell() {
        // Arrange
        let viewModels = createMockViewModels()
        sut.success(viewModels: viewModels)
        
        // Act
        let cell = getCell(for: IndexPath(row: 0, section: 0)) as? TransactionsInfoTableViewCell
        
        XCTAssertNotNil(cell, "Ячейка должна быть типа TransactionsInfoTableViewCell")
    }
    
    func testCellForRowAtIndexPathSetsDesiredLabels() {
        
        // Arrange
        let viewModels = createMockViewModels()
        sut.success(viewModels: viewModels)

        // Act & Assert
        for (index, viewModel) in viewModels.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = getCell(for: indexPath) as? TransactionsInfoTableViewCell
            
            // Проверяем текст для каждого из viewModels
            XCTAssertEqual(cell?.testableToCurrencyLabel.text, viewModel.toCurrencyLabel)
            XCTAssertEqual(cell?.testableFromCurrencyLabel.text, viewModel.fromCurrencyLabel)
        }
    }
    
    func testCellForRowWithEmptyViewModel() {
        // Arrange: Пустой viewModel
        let viewModels = [TransactionsInfoViewModel(fromCurrencyLabel: "", toCurrencyLabel: "")]
        sut.success(viewModels: viewModels)

        // Act & Assert
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = getCell(for: indexPath) as? TransactionsInfoTableViewCell
        
        // Проверяем, что ячейка не сломана, даже если данные пустые
        XCTAssertEqual(cell?.testableToCurrencyLabel.text, "")
        XCTAssertEqual(cell?.testableFromCurrencyLabel.text, "")
    }
    
    func testTableViewWithEmptyViewModels() {
        // Arrange: Пустой список viewModels
        let viewModels = [TransactionsInfoViewModel]()
        sut.success(viewModels: viewModels)

        // Act
        let numberOfRows = sut.testableTableView.numberOfRows(inSection: 0)
        
        // Assert: Проверяем, что таблица не отобразит строк, если нет данных
        XCTAssertEqual(numberOfRows, 0)
    }
    
// TODO: - можно дописать в презентере обработку неверного формата валюты
    
    // MARK: - Helpers
    
    private func createMockViewModels() -> [TransactionsInfoViewModel] {
        return [
            TransactionsInfoViewModel(fromCurrencyLabel: "$ 100,00", toCurrencyLabel: "100,00 £"),
            TransactionsInfoViewModel(fromCurrencyLabel: "$ 200,00", toCurrencyLabel: "200,00 £"),
            TransactionsInfoViewModel(fromCurrencyLabel: "$ 300,00", toCurrencyLabel: "300,00 £")
        ]
    }
    
    private func getCell(for indexPath: IndexPath) -> UITableViewCell {
        return sut.tableView(sut.testableTableView, cellForRowAt: indexPath)
    }
}


// MARK: - MockTransactionsInfoPresenter

final class MockTransactionsInfoPresenter: TransactionsInfoPresenterProtocol {
    
    var didCallViewDidLoad = false
    
    var title: String?
    var header: String?
    

    weak var view: TransactionsInfoViewProtocol?
    
    func viewDidLoad() {
        didCallViewDidLoad = true
    }
    
    func getTransactionsTitle() -> String {
        return title!
    }
    
    func getHeader() -> String {
        return header!
    }
}
