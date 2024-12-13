//
//  ProductsSceneProtocols.swift
//  TradeTracker
//
//  Created by Alexander on 03.12.2024.
//

import UIKit
import TradeTrackerCore


protocol ProductsViewProtocol: AnyObject {
    var presenter: ProductsPresenterProtocol? { get set }
    func success(viewModels: [ProductViewModel])
}

protocol ProductsPresenterProtocol: AnyObject {
    var view: ProductsViewProtocol? { get set }
    func viewDidLoad()
    func tapOnTheProduct(with sku: String)
}

protocol ProductsModelProtocol {
    func fetchProducts() -> Result<[Product], DataServiceError>
}

protocol ProductsRouterProtocol: AnyObject {
    func showTransactionsInfo(with sku: String)
    func showAlert(title: String, message: String)
    func setRootViewController(root: UIViewController)
}
