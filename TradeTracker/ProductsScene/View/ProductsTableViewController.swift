//
//  ProductsTableViewController.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import UIKit

protocol ProductsViewProtocol: AnyObject {
    func update(viewModel: ProductsView.ViewModel)
    func showError()
    func showEmpty()
    func startLoader()
    func stopLoader()
}

class ProductsViewController: UIViewController {
    
    private lazy var customView = ProductsView()
    
    init() {
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
    }
}

extension ProductsViewController: ProductsViewProtocol {
    func showError() {
        customView.showError()
    }
    
    func showEmpty() {
        customView.showEmpty()
    }
        
    func update(viewModel: ProductsView.ViewModel) {
        customView.update(viewModel: viewModel)
    }
    
    func startLoader() {
        customView.startLoader()
    }
    
    func stopLoader() {
        customView.stopLoader()
    }
}
