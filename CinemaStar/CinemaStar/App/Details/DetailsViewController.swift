// DetailsViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// View деталей о фильме
final class DetailsViewController: UIViewController {
    private let detailsViewModel: DetailsViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
    }

    init(detailsViewModel: DetailsViewModelProtocol) {
        self.detailsViewModel = detailsViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        detailsViewModel = nil
        super.init(coder: coder)
    }
}
