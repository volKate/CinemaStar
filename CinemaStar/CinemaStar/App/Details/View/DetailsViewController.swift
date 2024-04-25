// DetailsViewController.swift
// Copyright © RoadMap. All rights reserved.

import SnapKit
import UIKit

/// View деталей о фильме
final class DetailsViewController: UIViewController {
    private let detailsViewModel: DetailsViewModelProtocol?

    private let detailsTableView = DetailsTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        detailsViewModel?.fetchMovieDetails()
    }

    private func setupView() {
        view.addSubview(detailsTableView)
        setupConstraints()
        if let detailsViewModel {
            detailsTableView.configure(with: detailsViewModel)
        }

        view.layer.insertSublayer(AppBackgroundGradientLayer(frame: view.bounds), at: 0)
        detailsTableView.backgroundColor = .clear
    }

    private func setupConstraints() {
        detailsTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
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
