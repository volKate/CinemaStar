// DetailsViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол ViewModel деталей фильма
protocol DetailsViewModelProtocol {
    /// Состояние загрузки данных
    var viewState: ObservableObject<ViewState<MovieDetails>> { get }
    /// Метод загрузки деталей фильма
    func fetchMovieDetails() async
    /// Метод воспроизведение фильма
    func watchMovie()
}

/// ViewModel экрана деталей о фильме
final class DetailsViewModel {
    private(set) var viewState: ObservableObject<ViewState<MovieDetails>> = .init(value: .initial)
    private var apiRequest: APIRequest<MovieDetailsResource>?
    private let movieId: Int
    private let coordinator: CatalogCoordinator

    init(movieId: Int, coordinator: CatalogCoordinator) {
        self.movieId = movieId
        self.coordinator = coordinator
    }
}

// MARK: - DetailsViewModel + DetailsViewModelProtocol

extension DetailsViewModel: DetailsViewModelProtocol {
    func fetchMovieDetails() async {
        viewState.value = .loading
        let resource = MovieDetailsResource(id: movieId)
        let request = APIRequest(resource: resource)
        apiRequest = request
        do {
            let movieDetailsDTO = try await request.execute()
            let movieDetails = MovieDetails(fromDTO: movieDetailsDTO)
            viewState.value = .data(movieDetails)
        } catch {
            viewState.value = .error(error)
        }
    }

    func watchMovie() {
        // show alert that feature is not implemented
    }
}
