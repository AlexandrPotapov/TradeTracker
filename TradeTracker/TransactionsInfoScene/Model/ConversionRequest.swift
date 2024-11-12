//
//  ConversionRequest.swift
//  TradeTracker
//
//  Created by Alexander on 08.11.2024.
//

import Foundation

struct ConversionRequest {
    let amount: Double
    let fromCurrency: String
    let toCurrency: String
    let rates: [Rate]
}
