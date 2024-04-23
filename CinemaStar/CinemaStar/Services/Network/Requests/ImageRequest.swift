// ImageRequest.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Запрос на сервер за изображением
final class ImageRequest {
    let url: URL

    init(url: URL) {
        self.url = url
    }
}

// MARK: - ImageRequest + NetworkRequest

extension ImageRequest: NetworkRequest {
    func decode(_ data: Data) throws -> URL? {
        let dataString = data.base64EncodedString()
        return URL(string: "data:image/png;base64," + dataString)
    }

    func execute() async throws -> URL? {
        try await load(url)
    }

    func convert(_ dto: URL?) throws -> URL? {
        dto
    }
}
