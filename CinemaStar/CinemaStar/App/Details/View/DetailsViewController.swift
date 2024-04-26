// DetailsViewController.swift
// Copyright © RoadMap. All rights reserved.

import SnapKit
import UIKit

/// View деталей о фильме
final class DetailsViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let heartImageName = "heart"
        static let heartFillImageName = "heart.fill"
    }

    // MARK: - Visual Components

    private let detailsTableView = DetailsTableView()
    private lazy var heartBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: Constants.heartImageName),
            target: self,
            action: #selector(handleFavoriteTapped)
        )
        return item
    }()

    // MARK: - Private Properties

    private let detailsViewModel: DetailsViewModelProtocol?

    // MARK: - Initializers

    init(detailsViewModel: DetailsViewModelProtocol) {
        self.detailsViewModel = detailsViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        detailsViewModel = nil
        super.init(coder: coder)
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        detailsViewModel?.fetchMovieDetails()
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        detailsViewModel?.isFavorite.bind { [weak self] isFavorite in
            self?.heartBarButtonItem
                .image = UIImage(systemName: isFavorite ? Constants.heartFillImageName : Constants.heartImageName)
        }

        detailsViewModel?.alertMessage.bind { [weak self] alertMessage in
            guard let alertMessage else { return }
            self?.showAlert(
                title: alertMessage.title,
                message: alertMessage.description,
                dismissText: alertMessage.dismissButtonText
            )
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

    private func showAlert(title: String, message: String? = nil, dismissText: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAlertAction = UIAlertAction(title: dismissText, style: .cancel)
        alert.addAction(okAlertAction)
        present(alert, animated: true)
    }

    @objc private func handleFavoriteTapped() {
        detailsViewModel?.handleToggleFavorite()
    }
}
