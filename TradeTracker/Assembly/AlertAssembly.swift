//
//  AlertAssembly.swift
//  TradeTracker
//
//  Created by Alexander on 06.12.2024.
//

import UIKit
import Swinject

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
