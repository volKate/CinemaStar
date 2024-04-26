// CatalogCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Координатор каталога фильмов
final class CatalogCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    private var navigationController: UINavigationController?

    func start() {
        let catalogViewModel = CatalogViewModel(coordinator: self)
        let catalogViewController = CatalogViewController(catalogViewModel: catalogViewModel)
        setAsRoot(catalogViewController)
    }

    func openMovieDetails(id: Int) {
        let detailsViewModel = DetailsViewModel(movieId: id, coordinator: self, storageService: UserDefaultsStorage())
        let detailsViewController = DetailsViewController(detailsViewModel: detailsViewModel)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
