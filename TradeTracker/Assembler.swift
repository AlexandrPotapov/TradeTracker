//
//  Assembler.swift
//  TradeTracker
//
//  Created by Alexander on 26.10.2024.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createProductScene(router: RouterProtocol) -> UIViewController
    func createTransactionsInfo(product: Product?, router: RouterProtocol) -> UIViewController
    func createAlert(title: String, message: String) -> UIViewController
}


class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    func createProductScene(router: RouterProtocol) -> UIViewController {
        let view = ProductsViewController()
        let dataLoader  = PlistDataLoader()
        let dataManager = DataManager(dataLoader: dataLoader)
        let presenter = ProductsPresenter(view: view, dataManager: dataManager, router: router)
        view.presenter = presenter
        return view
    }

    func createTransactionsInfo(product: Product?, router: RouterProtocol) -> UIViewController {
        let view = TransactionsInfoViewController()
        let dataLoader  = PlistDataLoader()
        let dataManager = DataManager(dataLoader: dataLoader)
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
