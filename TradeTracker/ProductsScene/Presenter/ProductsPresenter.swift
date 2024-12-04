//
//  ProductsPresenter.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

final class ProductsPresenter: ProductsPresenterProtocol {
    weak var view: ProductsViewProtocol?
    
    private let router: RouterProductsProtocol
    private var model: ProductsModelProtocol
    
    init(model: ProductsModelProtocol, router: RouterProductsProtocol) {
        self.model = model
        self.router = router
    }
    
    func attachView(_ view: ProductsViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        
        
        let result = model.getProductsInfo()
        
        switch result {
            case .success(let products):
            let productsViewModels = products.map { ProductViewModel(sku: $0.sku, transactionCount: String($0.transactionCount)) }
            view?.success(viewModels: productsViewModels)
        case .failure(let error):
            showAlertError(message: error.localizedDescription)
        }
    }
    

    
    func tapOnTheProduct(with sku: String) {
        router.showTransactionsInfo(with: sku)
    }

    
    private func showAlertError(message: String) {
        router.showAlert(title: "Error", message: message)
    }
}
