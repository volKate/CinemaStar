// NetworkRequest.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол запроса в сеть
protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    /// Метод декодирования данных
    func decode(_ data: Data) -> ModelType?
    /// Метод запуска запроса
    func execute(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
        var request = URLRequest(url: url)
        guard let apiToken = try? TokenStorage().getToken() else { return }
        request.setValue(apiToken, forHTTPHeaderField: "X-API-KEY")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let data = data, let value = self?.decode(data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            DispatchQueue.main.async { completion(value) }
        }
        task.resume()
    }
}
