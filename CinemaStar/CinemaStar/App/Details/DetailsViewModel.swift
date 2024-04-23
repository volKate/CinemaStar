// DetailsViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол ViewModel деталей фильма
protocol DetailsViewModelProtocol {
    /// Состояние загрузки данных
    var viewState: ObservableObject<ViewState<MovieDetails>> { get }
    /// Состояние "в избранном"
    var isFavorite: ObservableObject<Bool> { get }
    /// Метод загрузки деталей фильма
    func fetchMovieDetails() async
    /// Метод воспроизведение фильма
    func watchMovie()
    /// Метод обновления состояния "в избранном"
    func handleToggleFavorite()
}

/// ViewModel экрана деталей о фильме
final class DetailsViewModel {
    private enum Constants {
        static let favoritesStorageKey = "favoriteMovies"
    }

    private(set) var viewState: ObservableObject<ViewState<MovieDetails>> = .init(value: .initial)
    private(set) var isFavorite: ObservableObject<Bool> = .init(value: false)

    private var apiRequest: APIRequest<MovieDetailsResource>?
    private let movieId: Int
    private let coordinator: CatalogCoordinator
    private let storageService: Storage

    init(movieId: Int, coordinator: CatalogCoordinator, storageService: Storage) {
        self.movieId = movieId
        self.coordinator = coordinator
        self.storageService = storageService
        setupBindings()
    }

    private func setupBindings() {
        viewState.bind { [weak self] viewState in
            switch viewState {
            case let .data(data):
                self?.syncIsFavoriteState(id: data.id)
            default:
                return
            }
        }
    }

    private func getFavoriteMovies() -> [Int] {
        do {
            return try storageService.value(forKey: Constants.favoritesStorageKey)
        } catch {
            return []
        }
    }

    private func syncIsFavoriteState(id: Int) {
        let favoriteMovies = getFavoriteMovies()
        isFavorite.value = favoriteMovies.contains(id)
    }
}

// MARK: - DetailsViewModel + DetailsViewModelProtocol

extension DetailsViewModel: DetailsViewModelProtocol {
    func handleToggleFavorite() {
        isFavorite.value.toggle()
        var favoriteMovies = getFavoriteMovies()

        if isFavorite.value {
            favoriteMovies.append(movieId)
        } else {
            if let movieIndex = favoriteMovies.firstIndex(of: movieId) {
                favoriteMovies.remove(at: movieIndex)
            }
        }

        do {
            try storageService.save(favoriteMovies, forKey: Constants.favoritesStorageKey)
        } catch {
            isFavorite.value.toggle()
        }

        syncIsFavoriteState(id: movieId)
    }

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
