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
    func decode(_ data: Data) -> Data? {
        data
    }

    func execute(withCompletion completion: @escaping (Data?) -> Void) {
        load(url, withCompletion: completion)
    }
}
