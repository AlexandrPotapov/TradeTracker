//
//  TransactionsInfoTableViewCell.swift
//  TradeTracker
//
//  Created by Alexander on 27.10.2024.
//

import UIKit

final class TransactionsInfoTableViewCell: UITableViewCell {
    
    static let id = "TransactionInfoTableViewCell"
    
    private lazy var fromCurrencyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var toCurrencyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        backgroundColor = .systemBackground
        selectionStyle = .none
        tintColor = .systemRed
        
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with viewModel: TransactionsInfoViewModel) {
        fromCurrencyLabel.text = viewModel.fromCurrencyLabel
        toCurrencyLabel.text = viewModel.toCurrencyLabel
    }
}

private extension TransactionsInfoTableViewCell {
    private func setupSubviews() {
        stack.addArrangedSubview(fromCurrencyLabel)
        stack.addArrangedSubview(toCurrencyLabel)
        contentView.addSubview(stack)
        contentView.addSubview(line)
        setupConstraints()
    }
    
    func setupConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            line.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 2.0),
            line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stack.heightAnchor.constraint(equalToConstant: 40),
            
            line.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale)
        ])
    }
}


extension TransactionsInfoTableViewCell {
#if DEBUG
    var testableFromCurrencyLabel: UILabel {
        fromCurrencyLabel
    }
    
    var testableToCurrencyLabel: UILabel {
        toCurrencyLabel
    }
#endif
}
