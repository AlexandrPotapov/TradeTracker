//
//  Assembler.swift
//  TradeTracker
//
//  Created by Alexander on 26.10.2024.
//

import UIKit

protocol AssemblyBuilderProtocol {
    init(dataManager: DataManagerProtocol)
    func createProductScene(router: RouterProtocol) -> UIViewController
    func createTransactionsInfo(product: Product?, router: RouterProtocol) -> UIViewController
    func createAlert(title: String, message: String) -> UIViewController
}


class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    private let dataManager: DataManagerProtocol

    required init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    
    func createProductScene(router: RouterProtocol) -> UIViewController {
        let view = ProductsViewController()
        let presenter = ProductsPresenter(view: view, dataManager: dataManager, router: router)
        view.presenter = presenter
        return view
    }

    func createTransactionsInfo(product: Product?, router: RouterProtocol) -> UIViewController {
        let view = TransactionsInfoViewController()
        let presenter = TransactionsInfoPresenter(view: view, dataManager: dataManager, router: router, product: product)
        view.presenter = presenter
        return view
    }
    
    func createAlert(title: String, message: String) -> UIViewController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}
