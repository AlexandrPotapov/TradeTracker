//
//  DataLoader.swift
//  TradeTracker
//
//  Created by Alexander on 25.10.2024.
//

import Foundation

public protocol DataLoaderProtocol {
    func load<T: Decodable>(from fileURL: URL, as type: T.Type) -> Result<T, DataServiceError>
}

public final class DataLoader: DataLoaderProtocol {
    public init() {}
    public func load<T: Decodable>(from fileURL: URL, as type: T.Type) -> Result<T, DataServiceError> {
        do {
            let data = try Data(contentsOf: fileURL)
            let decodedData = try PropertyListDecoder().decode(type, from: data)
            return .success(decodedData)
        } catch {
            return .failure(.dataLoadingFailed(underlyingError: error))
        }
    }
}
