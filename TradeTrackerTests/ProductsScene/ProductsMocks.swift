//
//  ProductsMocks.swift
//  TradeTrackerTests
//
//  Created by Alexander on 08.12.2024.
//

import XCTest
@testable import TradeTracker

// MARK: - ProductsRouterTests

final class TransactionInfoBuilderMock: TransactionInfoBuilderProtocol {
    var capturedProductSku: String?

    func buildTransactionsInfo(with sku: String) -> UIViewController {
        capturedProductSku = sku
        return UIViewController()
    }
}

final class AlertBuilderMock: AlertBuilderProtocol {
    var capturedTitle: String?
    var capturedMessage: String?

    func buildAlert(title: String, message: String) -> UIViewController {
        capturedTitle = title
        capturedMessage = message
        return UIViewController()
    }
}

final class NavigationControllerMock: UINavigationController {
    
    var presentedVC: UIViewController?
    var rootViewController: UIViewController?
    
    override init(rootViewController: UIViewController) {
         super.init(nibName: nil, bundle: nil)
         self.viewControllers = [rootViewController]
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }

}

final class ViewControllerMock: UIViewController {
    var presentedVC: UIViewController?

    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        
        presentedVC = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

// MARK: - PresenterProductsTests

final class ProductsViewMock: ProductsViewProtocol {
    var presenter: ProductsPresenterProtocol?
    
    var viewModels: [ProductViewModel]?

    func success(viewModels: [ProductViewModel]) {
        self.viewModels = viewModels
    }
}

final class ProductsModelStub: ProductsModelProtocol {
    var result: Result<[Product], DataServiceError>?

    func fetchProducts() -> Result<[Product], DataServiceError> {
        return result ?? .failure(.resourceNotFound(name: "Mock"))
    }
}

final class ProductsRouterMock: ProductsRouterProtocol {
    
    var alertMessage: String?
    var capturedProductSku: String?


    func showTransactionsInfo(with sku: String) {
        capturedProductSku = sku
    }
    
    func setRootViewController(root: UIViewController) { }

    func showAlert(title: String, message: String) {
        alertMessage = message
    }
}

// MARK: - ModelProductsTests

final class TransactionDataManagerMock: TransactionDataManagerProtocol {
    
    var result: Result<[TransactionData], DataServiceError>?
        
    func loadTransactions() -> Result<[TransactionData], DataServiceError> {
        return result ?? .failure(.resourceNotFound(name: "Mock"))
    }
    
    func clearCache() {
        result = nil
    }
}

// MARK: - ProductsViewControllerTests, ProductsViewTests

final class ProductsPresenterMock: ProductsPresenterProtocol {
    var view:ProductsViewProtocol?
    
    var didCallViewDidLoad = false
    var capturedProductSku: String?
    
    func viewDidLoad() {
        didCallViewDidLoad = true
    }
    
    func tapOnTheProduct(with sku: String) {
        capturedProductSku = sku
    }
}
