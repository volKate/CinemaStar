// DetailsViewController.swift
// Copyright © RoadMap. All rights reserved.

import SnapKit
import UIKit

/// View деталей о фильме
final class DetailsViewController: UIViewController {
    private let detailsViewModel: DetailsViewModelProtocol?

    private let detailsTableView = DetailsTableView()
    private lazy var heartBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "heart"),
            target: self,
            action: #selector(handleFavoriteTapped)
        )
        return item
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        detailsViewModel?.fetchMovieDetails()
        setupBindings()
    }

    private func setupBindings() {
        detailsViewModel?.isFavorite.bind { [weak self] isFavorite in
            self?.heartBarButtonItem.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        }
    }

    private func setupView() {
        view.addSubview(detailsTableView)
        setupConstraints()
        if let detailsViewModel {
            detailsTableView.configure(with: detailsViewModel)
        }

        view.backgroundColor = .white
        view.layer.insertSublayer(AppBackgroundGradientLayer(frame: view.bounds), at: 0)
        detailsTableView.backgroundColor = .clear
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = heartBarButtonItem
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
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

    @objc private func handleFavoriteTapped() {
        detailsViewModel?.handleToggleFavorite()
    }
}
