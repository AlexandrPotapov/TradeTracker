//
//  ProductsPresenter.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

protocol ProductsViewProtocol: AnyObject {
    func success(viewModels: [ProductViewModel])
}

protocol ProductsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func tapOnTheProduct(with sku: String)

}

final class ProductsPresenter: ProductsPresenterProtocol {
    weak var view: ProductsViewProtocol?
    
    private let router: RouterProductsProtocol
    private var model: ProductsModelProtocol
    
    init(view: ProductsViewProtocol, model: ProductsModelProtocol, router: RouterProductsProtocol) {
        self.view = view
        self.model = model
        self.router = router
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
