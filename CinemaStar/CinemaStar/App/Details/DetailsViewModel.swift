// DetailsViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол ViewModel деталей фильма
protocol DetailsViewModelProtocol {
    /// Состояние загрузки данных
    var viewState: ObservableObject<ViewState<MovieDetails>> { get }
    /// Состояние "в избранном"
    var isFavorite: ObservableObject<Bool> { get }
    /// Системное сообщение
    var alertMessage: ObservableObject<AlertMessage?> { get }
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
        static let inDevelopmentTitle = "Упс!"
        static let inDevelopmentMessage = "Функционал в разработке :("
        static let errorTitle = "Ошибка"
        static let errorMessage = "Произошла ошибка загрузки, попробуйте снова"
    }

    private(set) var viewState: ObservableObject<ViewState<MovieDetails>> = .init(value: .initial)
    private(set) var isFavorite: ObservableObject<Bool> = .init(value: false)
    private(set) var alertMessage: ObservableObject<AlertMessage?> = .init(value: nil)

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
        syncIsFavoriteState(id: movieId)
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
                    self?.alertMessage.value = AlertMessage(
                        title: Constants.errorTitle,
                        description: Constants.errorMessage
                    )
                    return
                }
                let movieDetails = MovieDetails(fromDTO: movieDetailsDTO)
                self?.viewState.value = .data(movieDetails)
            }
        }
    }

    func watchMovie() {
        alertMessage.value = AlertMessage(
            title: Constants.inDevelopmentTitle,
            description: Constants.inDevelopmentMessage
        )
    }
}
