//
//  Queue.swift
//  TradeTracker
//
//  Created by Alexander on 13.11.2024.
//

import Foundation

struct Queue<Element> {
    private var elements = [Element]()
    
    
    var isEmpty: Bool {
        elements.isEmpty
    }
    
    var count: Int {
        elements.count
    }
    
    // MARK: - Operations
    mutating func enqueue(_ element: Element) {
        elements.append(element)

    }
    
    mutating func dequeue() -> Element? {
        guard !elements.isEmpty else {
            return nil
        }
        
        return elements.removeFirst()
    }
}
