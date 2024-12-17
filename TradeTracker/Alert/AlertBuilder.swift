//
//  AlertBuilder.swift
//  TradeTracker
//
//  Created by Alexander on 26.10.2024.
//

import UIKit
import Swinject
import Features


//protocol AlertBuilderProtocol {
//    func buildAlert(title: String, message: String) -> UIViewController
//}


final class AlertBuilder: AlertBuilderProtocol {
    private let resolver: Resolver

    init(resolver: Resolver) {
        self.resolver = resolver
    }

    func buildAlert(title: String, message: String) -> UIViewController {
        guard let alertController = resolver.resolve(UIViewController.self, name: "alertVC", arguments: title, message) else {
            fatalError("Failed to resolve AlertViewController")
        }
        return alertController
    }
}
