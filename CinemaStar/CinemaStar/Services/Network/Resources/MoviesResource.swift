// MoviesResource.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Ресурс фильмов
struct MoviesResource: APIResource {
    typealias ModelType = WrapperDTO

    var path = "/movie/search"
    var query: String? = "История"
}
