//
//  TransactionsInfoViewController.swift
//  TradeTracker
//
//  Created by Alexander on 27.10.2024.
//

import UIKit

final class TransactionsInfoViewController: UIViewController {
    
    var presenter: TransactionsInfoPresenterProtocol?
    
    private lazy var customView = TransactionsInfoView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.presenter = presenter
        presenter?.viewDidLoad()
        navigationItem.title = presenter?.getTransactionsTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
}

// MARK: - ProductsViewProtocol
extension TransactionsInfoViewController: TransactionsInfoViewProtocol {
    func success(viewModels: [TransactionsInfoViewModel]) {
        customView.success(viewModels: viewModels)
    }
}
