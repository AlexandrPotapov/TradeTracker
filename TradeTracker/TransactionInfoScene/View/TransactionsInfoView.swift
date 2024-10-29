//
//  TransactionsInfoView.swift
//  TradeTracker
//
//  Created by Alexander on 27.10.2024.
//

import UIKit

class TransactionsInfoView: UIView {
    
    var presenter: TransactionsInfoPresenter!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TransactionsInfoTableViewCell.self, forCellReuseIdentifier: TransactionsInfoTableViewCell.id)
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        return tableView
    }()
    
    private lazy var headerView: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func success() {
        headerView.text = presenter.header
        tableView.reloadData()
    }
    
}


// MARK: - UITableViewDataSource
extension TransactionsInfoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.viewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModels = presenter.viewModels,
              let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsInfoTableViewCell.id) as? TransactionsInfoTableViewCell else {
            return UITableViewCell()
        }
        
        let transactionsInfoViewModel = viewModels[indexPath.row]
        cell.update(with: transactionsInfoViewModel)
        return cell
    }
    
    
}
// MARK: - Private extension
private extension TransactionsInfoView {
    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(headerView)
        addSubview(line)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 20),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            line.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            line.heightAnchor.constraint(equalToConstant: 2),
            line.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            line.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: line.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
