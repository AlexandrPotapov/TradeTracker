//
//  Rate.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

struct RateData: Codable {
    let from: String     // Исходная валюта
    let to: String       // Целевая валюта
    let rate: String     // Курс обмена
}

