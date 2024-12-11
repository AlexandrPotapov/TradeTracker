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
        
        guard let rate = Double(rate) else { return nil }
        self.from = from
        self.to = to
        self.rate = rate
    }
    
    init(from: String, to: String, rate: Double) {
        
        self.from = from
        self.to = to
        self.rate = rate
    }
}
