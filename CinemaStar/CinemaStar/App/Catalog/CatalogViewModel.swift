// CatalogViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол ViewModel каталога фильмов
protocol CatalogViewModelProtocol {
    /// Превью фильмов в каталоге
    var movies: ObservableObject<[MoviePreview]> { get }
    /// Метод загрузки фильмов в каталоге
    func fetchMovies() async
    /// Метод открытия деталей о фильме
    func showMovieDetails()
}

/// ViewModel экрана католога фильмов
final class CatalogViewModel {
    private(set) var movies: ObservableObject<[MoviePreview]> = .init(value: [])
    private var apiRequest: APIRequest<MoviesResource>?
}

// MARK: - CatalogViewModel + CatalogViewModelProtocol

extension CatalogViewModel: CatalogViewModelProtocol {
    func fetchMovies() async {
        let resource = MoviesResource()
        let request = APIRequest(resource: resource)
        apiRequest = request
        do {
            let moviesDTO = try await request.execute()
            let moviePreviews = moviesDTO.docs.map { MoviePreview(fromDTO: $0) }
            movies.value = moviePreviews
        } catch {
            movies.value = []
        }
    }

    func showMovieDetails() {
        // navigate to details page through coordinator
    }
}
