//
//  ProductsPresenter.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

protocol ProductsPresenterProtocol: AnyObject {
    init(view: ProductsViewProtocol, dataManager: DataManagerProtocol, router: RouterProtocol)
    func viewDidLoad()
    func tapOnTheProduct(product: Product?)
}

final class ProductsPresenter: ProductsPresenterProtocol {
    weak var view: ProductsViewProtocol?
    private let dataManager: DataManagerProtocol!
//    private var products: [Product] = []
    
    init(view: ProductsViewProtocol, dataManager: DataManagerProtocol, router: RouterProtocol) {
        self.view = view
        self.dataManager = dataManager
    }
    
    func viewDidLoad() {
        if let products = dataManager.getProductsInfo() {
            let productsViewModels = products.map { Product(sku: $0.sku, transactionCount: String($0.transactionCount)) }
            view?.success(viewModels: productsViewModels)
            print(productsViewModels)
        } else {
            view?.failure(errorMessage: "Error loading products")
        }
    }
    
    func tapOnTheProduct(product: Product?) {
        
    }
    
    
}
