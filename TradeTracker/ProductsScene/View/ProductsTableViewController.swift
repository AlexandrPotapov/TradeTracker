//
//  ProductsTableViewController.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import UIKit

final class ProductsViewController: UIViewController {
    
    var presenter: ProductsPresenterProtocol?
    
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
        navigationItem.title = "Products"
        customView.presenter = presenter
        presenter?.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backButtonTitle = self.title
    }
}

extension ProductsViewController: ProductsViewProtocol {
    func success(viewModels: [ProductViewModel]) {
        customView.success(viewModels: viewModels)
    }
}
