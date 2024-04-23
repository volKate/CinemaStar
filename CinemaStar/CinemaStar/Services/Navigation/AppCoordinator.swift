// AppCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Главный координатор приложения
final class AppCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []

    func start() {
        let catalogCoordinator = CatalogCoordinator()
        catalogCoordinator.start()
        add(coordinator: catalogCoordinator)
    }
}
