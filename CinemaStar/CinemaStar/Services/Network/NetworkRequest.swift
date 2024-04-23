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
        var request = URLRequest(url: url)
        request.setValue("728PDV2-K4V418S-KX7KN0Q-XFDCZ5A", forHTTPHeaderField: "X-API-KEY")
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decode(data)
    }
}
