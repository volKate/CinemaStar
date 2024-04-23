// APIResource.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Ресурс запрашиваемый через API
protocol APIResource {
    associatedtype ModelType: Decodable
    /// Адрес ресурса
    var path: String { get }
    /// Параметр поиска
    var query: String? { get }
}

extension APIResource {
    private var baseUrl: String {
        "https://api.kinopoisk.dev/v1.4"
    }

    var url: URL? {
        let url = URL(string: baseUrl)?.appending(path: path)
        guard let query else { return url }
        return url?.appending(queryItems: [URLQueryItem(name: "query", value: query)])
    }
}
