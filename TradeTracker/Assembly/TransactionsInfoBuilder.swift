//
//  TransactionInfoBuilder.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import UIKit
import Swinject
import Features

final class TransactionsInfoBuilder: TransactionInfoBuilderProtocol {
    
    private let resolver: Resolver

    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    func buildTransactionsInfo(with sku: String) -> UIViewController {
        guard let viewController = resolver.resolve(UIViewController.self, name: "transactionsInfoScene", argument: sku) else {
            fatalError("Failed to resolve TransactionsInfoViewController")
        }
        return viewController
    }
}

