//
//  Products.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import UIKit

final class ProductsView: UIView {
    
    private var viewModels: [Product]?
    
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
    
    func failure(errorMessage: String) {
        
    }
    
    func success(viewModels: [Product]) {
        self.viewModels = viewModels
    }
    
    func showEmpty() {
        
    }
    
    func startLoader() {
        
    }
    
    func stopLoader() {
        
    }

}

// MARK: - UITableViewDataSource
extension ProductsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModels = viewModels, let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.id) as? ProductsTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModels[indexPath.row]
        
        let cellModel = Product(
            sku: item.sku,
            transactionCount: item.transactionCount)
        cell.update(with: cellModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
