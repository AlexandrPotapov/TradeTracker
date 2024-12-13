//
//  RateData.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

public struct RateData: Codable {
    public let from: String     // Исходная валюта
    public let to: String       // Целевая валюта
    public let rate: String     // Курс обмена
    
    public init(from: String, to: String, rate: String) {
        self.from = from
        self.to = to
        self.rate = rate
    }
}

