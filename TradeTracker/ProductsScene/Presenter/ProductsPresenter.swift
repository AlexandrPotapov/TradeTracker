//
//  ProductsPresenter.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

protocol ProductsViewProtocol: AnyObject {
    func success()
}

protocol ProductsPresenterProtocol: AnyObject {
    var products: [Product]? { get set }
    init(view: ProductsViewProtocol, dataManager: DataManagerProtocol, router: RouterProtocol)
    func viewDidLoad()
    func tapOnTheProduct(product: Product?)
}

final class ProductsPresenter: ProductsPresenterProtocol {
    weak var view: ProductsViewProtocol?
    var products: [Product]?

    private let dataManager: DataManagerProtocol!
    private let router: RouterProtocol!
    
    init(view: ProductsViewProtocol, dataManager: DataManagerProtocol, router: RouterProtocol) {
        self.view = view
        self.dataManager = dataManager
        self.router = router
    }
    
    func viewDidLoad() {
        if let products = dataManager.getProductsInfo() {
            let productsViewModels = products.map { Product(sku: $0.sku, transactionCount: String($0.transactionCount)) }
            self.products = productsViewModels
            view?.success()
        } else {
            showAlertError()
        }
    }
    
    func tapOnTheProduct(product: Product?) {
        router?.showTransactionsInfo(product: product)
    }
    
    private func showAlertError() {
        router?.showAlert(title: "Error", message: "Erorr loading products")
    }
    
}
