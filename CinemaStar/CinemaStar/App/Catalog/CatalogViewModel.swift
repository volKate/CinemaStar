// CatalogViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол ViewModel каталога фильмов
protocol CatalogViewModelProtocol {
    /// Состояние загрузки данных
    var viewState: ObservableObject<ViewState<[MoviePreview]>> { get }
    /// Метод загрузки фильмов в каталоге
    func fetchMovies() async
    /// Метод открытия деталей о фильме
    func showMovieDetails(id: Int)
}

/// ViewModel экрана католога фильмов
final class CatalogViewModel {
    typealias MoviePreviewsViewState = ViewState<[MoviePreview]>
    private(set) var viewState: ObservableObject<MoviePreviewsViewState> = .init(value: .initial)
    private var apiRequest: APIRequest<MoviesResource>?
    private let coordinator: CatalogCoordinator

    init(coordinator: CatalogCoordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - CatalogViewModel + CatalogViewModelProtocol

extension CatalogViewModel: CatalogViewModelProtocol {
    func fetchMovies() async {
        viewState.value = .loading
        let resource = MoviesResource()
        let request = APIRequest(resource: resource)
        apiRequest = request
        do {
            let moviesDTO = try await request.execute()
            let moviePreviews = moviesDTO.docs.map { MoviePreview(fromDTO: $0) }
            viewState.value = .data(moviePreviews)
        } catch {
            viewState.value = .error(error)
        }
    }

    func showMovieDetails(id: Int) {
        coordinator.openMovieDetails(id: id)
    }
}
