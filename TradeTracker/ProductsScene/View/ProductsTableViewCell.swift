//
//  ProductsTableViewCell.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import UIKit

final class ProductsTableViewCell: UITableViewCell {
    
    static let id = "ProductsTableViewCell" // ID для регистрации
    
    private lazy var skuLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    private lazy var transationCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
  
    private lazy var transationsTextLabel: UILabel = {
        let label = UILabel()
        label.text = "transations"
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return imageView
    }()
    
    private lazy var transationsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [transationCountLabel, transationsTextLabel, chevronImageView])
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
  
    private lazy var stack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [skuLabel, transationsStack])
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
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

    func update(with viewModel: Product) {
        skuLabel.text = viewModel.sku
        transationCountLabel.text = viewModel.transactionCount
    }
}

private extension ProductsTableViewCell {
    
    func setupSubviews() {
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
