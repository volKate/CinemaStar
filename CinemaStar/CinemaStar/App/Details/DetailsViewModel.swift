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
    func fetchMovieDetails()
    /// Метод воспроизведение фильма
    func watchMovie()
    /// Метод обновления состояния "в избранном"
    func handleToggleFavorite()
    /// Метод загрузки изображения
    func loadImage(with url: URL, completion: @escaping (Data?) -> Void)
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
    private let loadImageService: LoadImageServiceProtocol

    init(
        movieId: Int,
        coordinator: CatalogCoordinator,
        storageService: Storage,
        loadImageService: LoadImageServiceProtocol
    ) {
        self.movieId = movieId
        self.coordinator = coordinator
        self.storageService = storageService
        self.loadImageService = loadImageService
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
    func loadImage(with url: URL, completion: @escaping (Data?) -> Void) {
        loadImageService.load(with: url, completion: completion)
    }

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

    func fetchMovieDetails() {
        viewState.value = .loading
        let resource = MovieDetailsResource(id: movieId)
        let request = APIRequest(resource: resource)
        apiRequest = request

        request.execute { movieDetailsDTO in
            DispatchQueue.main.async { [weak self] in
                guard let movieDetailsDTO else {
                    self?.viewState.value = .error(NetworkError.noData)
                    return
                }
                let movieDetails = MovieDetails(fromDTO: movieDetailsDTO)
                self?.viewState.value = .data(movieDetails)
            }
        }
    }

    func watchMovie() {
        // show alert that feature is not implemented
    }
}
