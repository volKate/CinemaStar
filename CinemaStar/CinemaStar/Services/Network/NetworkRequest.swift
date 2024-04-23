// NetworkRequest.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол запроса в сеть
protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    /// Метод декодирования данных
    func decode(_ data: Data) throws -> ModelType
    /// Метод запуска запроса
    func execute() async throws -> ModelType
}

extension NetworkRequest {
    func load(_ url: URL) async throws -> ModelType {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decode(data)
    }
}
