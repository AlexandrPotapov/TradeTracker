//
//  SharedDataManagerAssembly.swift
//  TradeTracker
//
//  Created by Alexander on 04.12.2024.
//

import Foundation
import Swinject
import TradeTrackerCore

final class SharedDataManagerAssembly: Assembly {
    func assemble(container: Container) {
        // Регистрация DataLoaderProtocol
        container.register(DataLoaderProtocol.self) { _ in
            DataLoader()
        }

        // Регистрация TransactionDataManagerProtocol
        container.register(TransactionDataManagerProtocol.self) { resolver in
            let dataLoader = resolver.resolve(DataLoaderProtocol.self)!
            return TransactionDataManager(dataLoader: dataLoader)
        }

        // Регистрация DataManagerWithRateProtocol
        container.register(DataManagerWithRateProtocol.self) { resolver in
            let dataLoader = resolver.resolve(DataLoaderProtocol.self)!
            let transactionDataManager = resolver.resolve(TransactionDataManagerProtocol.self)!
            return DataManagerWithRate(dataLoader: dataLoader, transactionDataManager: transactionDataManager)
        }

    }
}
