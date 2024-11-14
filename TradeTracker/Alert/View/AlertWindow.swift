//
//  AlertWindow.swift
//  TradeTracker
//
//  Created by Alexander on 13.11.2024.
//

import Foundation
import UIKit

protocol AlertWindowDelegate: AnyObject {
    func alertWindow(_ alertWindow: AlertPresenterProtocol, didDismissAlert alertController: UIViewController)
}

protocol AlertPresenterProtocol {
    var delegate: AlertWindowDelegate? { get set }
    func presentAlert(_ alert: UIViewController)
}


class AlertWindow: UIWindow, HoldingDelegate, AlertPresenterProtocol {
    weak var delegate: AlertWindowDelegate?
    
    // MARK: - Init
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        windowLevel = .alert
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Unavailable")
    }
    
    // MARK: - AlertPresenterProtocol

    func presentAlert(_ alert: UIViewController) {
        let holdingViewController = HoldingViewController(withAlertController: alert)
        holdingViewController.delegate = self
        rootViewController = holdingViewController
        makeKeyAndVisible()
    }
    
    // MARK: - HoldingDelegate
    
    func viewController(_ viewController: AlertHoldingViewProtocol, didDismissAlert alertController: UIViewController) {
        resignKeyAndHide()
        delegate?.alertWindow(self, didDismissAlert: alertController)
    }
    
    // MARK: - Resign
    
    private func resignKeyAndHide() {
        resignKey()
        isHidden = true
    }
}
