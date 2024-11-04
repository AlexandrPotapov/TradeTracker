//
//  Rate.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import Foundation

struct Rate {
    let from: String     // Исходная валюта
    let to: String       // Целевая валюта
    let rate: Double     // Курс обмена
    
    init?(from: String, to: String, rate: String) {
        self.from = from
        self.to = to
        
        if let rate = Double(rate) {
            self.rate = rate
        } else {
            return nil
        }
    }
}
