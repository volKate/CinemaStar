// CatalogCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Координатор каталога фильмов
final class CatalogCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []

    private var navigationController: UINavigationController?
    private let loadImageService = LoadImageProxy(service: LoadImageService())
    private let networkService = NetworkService()

    func start() {
        let catalogViewModel = CatalogViewModel(
            coordinator: self,
            loadImageService: loadImageService,
            networkService: networkService
        )
        let catalogViewController = CatalogViewController(catalogViewModel: catalogViewModel)
        let navigationController = UINavigationController(rootViewController: catalogViewController)
        self.navigationController = navigationController
        setAsRoot(navigationController)
    }

    func openMovieDetails(id: Int) {
        let detailsViewModel = DetailsViewModel(
            movieId: id,
            coordinator: self,
            storageService: UserDefaultsStorage(),
            loadImageService: loadImageService,
            networkService: networkService
        )
        let detailsViewController = DetailsViewController(detailsViewModel: detailsViewModel)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
