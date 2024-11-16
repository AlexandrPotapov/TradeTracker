//
//  HoldingViewController.swift
//  TradeTracker
//
//  Created by Alexander on 13.11.2024.
//

import Foundation
import UIKit

protocol HoldingDelegate: AnyObject {
    func viewController(_ viewController: AlertHoldingViewProtocol, didDismissAlert alertController: UIViewController)
}


protocol AlertHoldingViewProtocol: AnyObject {
    var delegate: HoldingDelegate? { get set }
}
 
class HoldingViewController: UIViewController, AlertHoldingViewProtocol {
    private let alertController: UIViewController
    
    weak var delegate: HoldingDelegate?
    
    // MARK: - Init
    
    init(withAlertController alertController: UIViewController) {
        self.alertController = alertController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Dismiss
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        //Called when a UIAlertController instance is dismissed
        super.dismiss(animated: flag) {
            completion?()

            self.delegate?.viewController(self, didDismissAlert: self.alertController)
        }
    }
}


//#if DEBUG
//extension HoldingViewController {
//    var testAlertController: UIViewController {
//        alertController
//    }
//}
//#endif
