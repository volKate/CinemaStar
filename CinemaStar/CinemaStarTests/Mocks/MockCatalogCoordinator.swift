// MockCatalogCoordinator.swift
// Copyright © RoadMap. All rights reserved.

@testable import CinemaStar
import Foundation

/// Мок сервиса навигации флоу каталога фильмов
final class MockCatalogCoordinator: CatalogCoordinatorProtocol {
    private(set) var openDetailsCallsWithIds: [Int] = []

    func openMovieDetails(id: Int) {
        openDetailsCallsWithIds.append(id)
    }

    func goBack() {}

    var childCoordinators: [any Coordinator] = []

    func start() {}
}
