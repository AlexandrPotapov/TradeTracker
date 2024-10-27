//
//  ProductsTableViewController.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import UIKit

protocol ProductsViewProtocol: AnyObject {
    func failure(errorMessage: String)
    func success(viewModels: [Product])
    func showEmpty()
    func startLoader()
    func stopLoader()
}

final class ProductsViewController: UIViewController {
    
    private lazy var customView = ProductsView()
    var presenter: ProductsPresenterProtocol!

    
    init() {
        presenter = nil
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Products"
        presenter.viewDidLoad()
    }
}

extension ProductsViewController: ProductsViewProtocol {
    func failure(errorMessage: String) {
        
    }
    
    func success(viewModels: [Product]) {
        customView.success(viewModels: viewModels)
    }
    
    func showEmpty() {
        
    }
    
    func startLoader() {
        
    }
    
    func stopLoader() {
        
    }
    
}
