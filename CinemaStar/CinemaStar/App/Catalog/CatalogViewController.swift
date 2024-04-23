// CatalogViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// View каталога фильмов
final class CatalogViewController: UIViewController {
    private let catalogViewModel: CatalogViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Catalog"
    }

    init(catalogViewModel: CatalogViewModelProtocol) {
        self.catalogViewModel = catalogViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        catalogViewModel = nil
        super.init(coder: coder)
    }
}
