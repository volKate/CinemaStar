// CatalogViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// View каталога фильмов
final class CatalogViewController: UIViewController {
    private var movies: [MoviePreview] = []
    private let catalogViewModel: CatalogViewModelProtocol?
    private enum Constants {
        static let header = "Смотри исторические\nфильмы на "
        static let logoText = "CINEMA STAR"
    }

    private let headerLabel: UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString(string: Constants.header, attributes: [
            .font: UIFont.inter(ofSize: 20) ?? .systemFont(ofSize: 20)
        ])
        text.append(NSAttributedString(string: Constants.logoText, attributes: [
            .font: UIFont.interBlack(ofSize: 20) ?? .boldSystemFont(ofSize: 20)
        ]))
        label.attributedText = text
        label.numberOfLines = 0
        return label
    }()

    private lazy var moviesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeFlowLayout())
        collectionView.register(
            PreviewCollectionViewCell.self,
            forCellWithReuseIdentifier: PreviewCollectionViewCell.cellID
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        catalogViewModel?.fetchMovies()
        catalogViewModel?.viewState.bind { [weak self] viewState in
            switch viewState {
            case let .data(movies):
                self?.movies = movies
            default:
                self?.movies = []
            }
            self?.moviesCollectionView.reloadData()
        }
    }

    init(catalogViewModel: CatalogViewModelProtocol) {
        self.catalogViewModel = catalogViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        catalogViewModel = nil
        super.init(coder: coder)
    }

    private func setupView() {
        view.layer.insertSublayer(AppBackgroundGradientLayer(frame: view.bounds), at: 0)
        view.addSubview(headerLabel)
        view.addSubview(moviesCollectionView)
        setupConstraints()
    }

    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalTo(view).inset(16)
        }

        moviesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(14)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func makeFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 14
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return flowLayout
    }
}

extension CatalogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let movie = movies[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PreviewCollectionViewCell.cellID,
            for: indexPath
        ) as? PreviewCollectionViewCell else { return .init() }
        cell.configure(name: "\(movie.name)\n\(movie.kpRating)")
        if let url = movie.posterUrl {
            catalogViewModel?.loadImage(with: url, completion: { data in
                guard let data else { return }
                cell.setImage(data: data)
            })
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        catalogViewModel?.showMovieDetails(id: movie.id)
    }
}

// MARK: - CatalogViewController + UICollectionViewDelegateFlowLayout

extension CatalogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (view.frame.width - 16 * 2 - 18) / 2
        return CGSize(width: width, height: 248)
    }
}
