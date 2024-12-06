//
//  AlertBuilder.swift
//  TradeTracker
//
//  Created by Alexander on 26.10.2024.
//

import UIKit
import Swinject

//protocol AlertBuilderProtocol {
//    func buildAlert(title: String, message: String) -> UIViewController
//}

//final class AlertBuilder: AlertBuilderProtocol {
//    func buildAlert(title: String, message: String) -> UIViewController {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        return alert
//    }
//}

//final class AlertAssembly: Assembly {
//    func assemble(container: Container) {
//        container.register(AlertBuilderProtocol.self) { _ in
//            AlertBuilder()
//        }
//    }
//}

final class AlertAssembly: Assembly {
    func assemble(container: Container) {
        // Регистрация UIAlertController
        container.register(UIViewController.self, name: "alertVC") { (_, title: String, message: String) in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            let vc = alert as UIViewController
            return vc
        }
    }
}
