// MovieDetailsResource.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Ресурс деталей фильма
struct MovieDetailsResource: APIResource {
    typealias ModelType = MovieDetailsDTO
    let id: Int

    var path: String {
        "/movie/\(id)"
    }

    var query: String?
}
