//
//  DataLoader.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

protocol DataLoader {
    func load<T: Decodable>(from fileURL: URL, as type: T.Type) -> T?
}

final class PlistDataLoader: DataLoader {
    func load<T: Decodable>(from fileURL: URL, as type: T.Type) -> T? {
        do {
            let data = try Data(contentsOf: fileURL)
            let decodedData = try PropertyListDecoder().decode(type, from: data)
            return decodedData
        } catch {
            print("Ошибка при загрузке данных из plist: \(error)")
            return nil
        }
    }
}
