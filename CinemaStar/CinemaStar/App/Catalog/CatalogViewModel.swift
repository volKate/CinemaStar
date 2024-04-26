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
    private var apiRequest: APIRequest<MoviesResource>?
    private let coordinator: CatalogCoordinator
    private let loadImageService: LoadImageServiceProtocol

    init(coordinator: CatalogCoordinator, loadImageService: LoadImageServiceProtocol) {
        self.coordinator = coordinator
        self.loadImageService = loadImageService
    }
}

// MARK: - CatalogViewModel + CatalogViewModelProtocol

extension CatalogViewModel: CatalogViewModelProtocol {
    func loadImage(with url: URL, completion: @escaping (Data?) -> Void) {
        loadImageService.load(with: url, completion: completion)
    }

    func fetchMovies() {
        viewState.value = .loading
        let resource = MoviesResource()
        let request = APIRequest(resource: resource)
        apiRequest = request
        request.execute { moviesDTO in
            DispatchQueue.main.async { [weak self] in
                guard let moviesDTO else {
                    self?.viewState.value = .error(NetworkError.noData)
                    return
                }
                let moviePreviews = moviesDTO.docs.map { MoviePreview(fromDTO: $0) }
                self?.viewState.value = .data(moviePreviews)
            }
        }
    }

    func showMovieDetails(id: Int) {
        coordinator.openMovieDetails(id: id)
    }
}
