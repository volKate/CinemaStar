// CatalogViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол ViewModel каталога фильмов
protocol CatalogViewModelProtocol {
    /// Состояние загрузки данных
    var viewState: ObservableObject<ViewState<[MoviePreview]>> { get }
    /// Метод загрузки фильмов в каталоге
    func fetchMovies()
    /// Метод открытия деталей о фильме
    func showMovieDetails(id: Int)
    /// Метод загрузки изображения
    func loadImage(with url: URL, completion: @escaping (Data?) -> Void)
}

/// ViewModel экрана католога фильмов
final class CatalogViewModel {
    typealias MoviePreviewsViewState = ViewState<[MoviePreview]>

    private(set) var viewState: ObservableObject<MoviePreviewsViewState> = .init(value: .initial)

    private let coordinator: CatalogCoordinatorProtocol
    private let loadImageService: LoadImageServiceProtocol
    private let networkService: NetworkServiceProtocol

    init(
        coordinator: CatalogCoordinatorProtocol,
        loadImageService: LoadImageServiceProtocol,
        networkService: NetworkServiceProtocol
    ) {
        self.coordinator = coordinator
        self.loadImageService = loadImageService
        self.networkService = networkService
    }
}

// MARK: - CatalogViewModel + CatalogViewModelProtocol

extension CatalogViewModel: CatalogViewModelProtocol {
    func loadImage(with url: URL, completion: @escaping (Data?) -> Void) {
        loadImageService.load(with: url, completion: completion)
    }

    func fetchMovies() {
        viewState.value = .loading
        networkService.loadMovies { [weak self] moviePreviews in
            guard let moviePreviews else {
                self?.viewState.value = .error
                return
            }
            self?.viewState.value = .data(moviePreviews)
        }
    }

    func showMovieDetails(id: Int) {
        coordinator.openMovieDetails(id: id)
    }
}
