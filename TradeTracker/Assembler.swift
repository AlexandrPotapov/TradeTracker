//
//  Assembler.swift
//  TradeTracker
//
//  Created by Alexander on 26.10.2024.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createProductScene(router: RouterProtocol) -> UIViewController
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

}
