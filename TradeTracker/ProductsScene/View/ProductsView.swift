//
//  Products.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import UIKit

final class ProductsView: UIView {
    
    var presenter: ProductsPresenterProtocol?
    var viewModels = [ProductViewModel]()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(ProductsTableViewCell.self, forCellReuseIdentifier: ProductsTableViewCell.id)
        view.separatorInset = .zero
        view.tableFooterView = UIView()
        view.backgroundColor = .systemBackground
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - ProductsViewProtocol
extension ProductsView: ProductsViewProtocol {
    func success(viewModels: [ProductViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ProductsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.id) as? ProductsTableViewCell else {
            return UITableViewCell()
        }
        
        let cellModel = viewModels[indexPath.row]
        cell.update(with: cellModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModels[indexPath.row]
        presenter?.tapOnTheProduct(with: product.sku)
    }
}

private extension ProductsView {
    
    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]
        )
    }
}

extension ProductsView {
#if DEBUG
var testTableView: UITableView {
    return tableView
}
#endif
}
