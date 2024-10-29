//
//  Products.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import UIKit

final class ProductsView: UIView {
    
    var presenter: ProductsPresenterProtocol!
    
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
    func success() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ProductsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let products = presenter.products, let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.id) as? ProductsTableViewCell else {
            return UITableViewCell()
        }
        
        let cellModel = products[indexPath.row]
        cell.update(with: cellModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = presenter.products?[indexPath.row]
        presenter.tapOnTheProduct(product: product)
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
