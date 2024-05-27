// DetailsRecommendationsTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка рекоммендаций фильмов
final class DetailsRecommendationsTableViewCell: UITableViewCell {
    // MARK: - Constants

    static let cellID = String(describing: DetailsRecommendationsTableViewCell.self)

    private enum Constants {
        static let title = "Смотрите также"
    }

    // MARK: - Visual Components

    private let previewsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            PreviewCollectionViewCell.self,
            forCellWithReuseIdentifier: PreviewCollectionViewCell.cellID
        )
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(228)
        }
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .interBold(ofSize: 16)
        label.textColor = .white
        label.text = Constants.title
        return label
    }()

    // MARK: - Private Properties

    private var viewModel: DetailsViewModelProtocol?
    private var previews: [MoviePreview] = []

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    // MARK: - Public Methods

    func configure(previews: [MoviePreview], viewModel: DetailsViewModelProtocol?) {
        self.viewModel = viewModel
        self.previews = previews
        previewsCollection.reloadData()
    }

    // MARK: - Private Methods

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(previewsCollection)
        contentView.addSubview(titleLabel)
        previewsCollection.dataSource = self
        previewsCollection.delegate = self

        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(16)
            make.top.equalTo(contentView)
        }
        previewsCollection.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalTo(contentView)
        }
    }
}

// MARK: - DetailsRecommendationsTableViewCell + UICollectionViewDataSource

extension DetailsRecommendationsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        previews.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let preview = previews[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PreviewCollectionViewCell.cellID,
            for: indexPath
        ) as? PreviewCollectionViewCell else { return .init() }
        cell.configure(name: preview.name)
        if let url = preview.posterUrl {
            viewModel?.loadImage(with: url, completion: { data in
                guard let data else { return }
                cell.setImage(data: data)
            })
        }
        return cell
    }
}

// MARK: - DetailsRecommendationsTableViewCell + UICollectionViewDelegateFlowLayout

extension DetailsRecommendationsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 170, height: 228)
    }
}
