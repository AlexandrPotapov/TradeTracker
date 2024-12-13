//
//  Rate.swift
//  TradeTracker
//
//  Created by Alexander on 01.11.2024.
//

import Foundation

public struct Rate {
    public let from: String     // Исходная валюта
    public let to: String       // Целевая валюта
    public let rate: Double     // Курс обмена
    
    public init?(from: String, to: String, rate: String) {
        
        guard let rate = Double(rate) else { return nil }
        self.from = from
        self.to = to
        self.rate = rate
    }
    
    public init(from: String, to: String, rate: Double) {
        
        self.from = from
        self.to = to
        self.rate = rate
    }
}
