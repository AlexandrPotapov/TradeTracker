//
//  AlertQueueManager.swift
//  TradeTracker
//
//  Created by Alexander on 14.11.2024.
//

import UIKit

protocol AlertQueueManagerProtocol {
    func enqueueAlert(_ : UIViewController)
    func dequeueAlert() -> UIViewController?
}

final class AlertQueueManager: AlertQueueManagerProtocol {
    
    private var alertQueue = Queue<UIViewController>()
    
    func enqueueAlert(_ alertController: UIViewController) {
        alertQueue.enqueue(alertController)
    }
    
    func dequeueAlert() -> UIViewController? {
        return alertQueue.dequeue()
    }
}
