//
//  AlertBuilder.swift
//  TradeTracker
//
//  Created by Alexander on 26.10.2024.
//

import UIKit

protocol AlertBuilderProtocol {
    func buildAlert(title: String, message: String) -> UIViewController
}

final class AlertBuilder: AlertBuilderProtocol {
    func buildAlert(title: String, message: String) -> UIViewController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}
