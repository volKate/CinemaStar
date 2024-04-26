// APIRequest.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Запрос на сервер за JSON данными
final class APIRequest<Resource: APIResource> {
    let resource: Resource

    init(resource: Resource) {
        self.resource = resource
    }
}

// MARK: - APIRequest + NetworkRequest

extension APIRequest: NetworkRequest {
    func decode(_ data: Data) throws -> Resource.ModelType {
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(Resource.ModelType.self, from: data)
        return decodedData
    }

    func execute() async throws -> Resource.ModelType {
        guard let url = resource.url else { throw NetworkError.invalidUrl }
        return try await load(url)
    }
}
