//
//  TransactionsInfoMocks.swift
//  TradeTrackerTests
//
//  Created by Alexander on 08.12.2024.
//

import XCTest
@testable import TradeTracker
import TradeTrackerCore
import Features



// MARK: - TransactionsInfoViewTests, TransactionsInfoViewControllerTests

final class TransactionsInfoPresenterMock: TransactionsInfoPresenterProtocol {
    
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

// MARK: - PresenterTransactionsTests

final class TransactionsInfoViewMock: TransactionsInfoViewProtocol {
    var presenter: TransactionsInfoPresenterProtocol?
    
    var successCalled = false
    var viewModels: [TransactionsInfoViewModel] = []
    
    func success(viewModels: [TransactionsInfoViewModel]) {
        successCalled = true
        self.viewModels = viewModels
    }
}

final class MockTransactionsInfoModel: TransactionsInfoModelProtocol {
    
    var result: Result<(transactions: [TransactionInfo], totalInGBP: Double), DataServiceError>?

    func getTransactionsInfo(for sku: String) -> Result<(transactions: [TransactionInfo], totalInGBP: Double), DataServiceError> {
        return result ?? .failure(.resourceNotFound(name: "Mock"))
    }
}

final class MockRouterTransactionsInfo: TransactionInfoRouterProtocol {
    
    var alertShown = false
    var alertMessage: String?

    func showAlert(title: String, message: String) {
        alertShown = true
        alertMessage = message
    }
}

// MARK: - RouterTransactionsInfoTests
final class AlertDisplayManagerMock: AlertDisplayManagerProtocol {
    
    var showNextAlertIsTrue = false
    
    func showNextAlertIfPresent() {
        showNextAlertIsTrue = true
    }
}

// MARK: - ModelTransactionsInfoTests

final class DataManagerWithRatesMock: DataManagerWithRateProtocol {
    
    var transactionsResult: Result<[TransactionData], DataServiceError>?
    var ratesResult: Result<[RateData], DataServiceError>?
    
    func loadRates() -> Result<[RateData], DataServiceError> {
        ratesResult ?? .failure(.resourceNotFound(name: "Mock"))
    }
    
    func loadTransactions() -> Result<[TransactionData], DataServiceError> {
        transactionsResult ?? .failure(.resourceNotFound(name: "Mock"))
    }
    
    func clearCache() {
    }
    
    
}

final class ConverterMock: ConverterProtocol {
    
    var converterResult: Result<Double, DataServiceError>?

    func convertToGBP(request: ConversionRequest) -> Result<Double, DataServiceError> {
        converterResult ?? .failure(.resourceNotFound(name: "Mock"))
    }
}
