//
//  Assembler.swift
//  TradeTracker
//
//  Created by Alexander on 26.10.2024.
//

import UIKit

protocol AssemblyAlertBuilderProtocol {
    func createAlert(title: String, message: String) -> UIViewController
}


final class AssemblyAlertBuilder: AssemblyAlertBuilderProtocol {
    func createAlert(title: String, message: String) -> UIViewController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}
