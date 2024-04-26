// DetailsActorsTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с актерами картины
final class DetailsActorsTableViewCell: UITableViewCell {
    // MARK: - Constants

    static let cellID = String(describing: DetailsActorsTableViewCell.self)

    private enum Constants {
        static let title = "Актеры и съемочная группа"
    }

    // MARK: - Visual Components

    private let actorsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            ActorCollectionViewCell.self,
            forCellWithReuseIdentifier: ActorCollectionViewCell.cellID
        )
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(97)
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
    private var actors: [Actor] = []

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

    func configure(actors: [Actor], viewModel: DetailsViewModelProtocol?) {
        self.viewModel = viewModel
        self.actors = actors
        actorsCollection.reloadData()
    }

    // MARK: - Private Methods

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(actorsCollection)
        contentView.addSubview(titleLabel)
        actorsCollection.dataSource = self
        actorsCollection.delegate = self

        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(16)
            make.top.equalTo(contentView)
        }
        actorsCollection.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.leading.trailing.bottom.equalTo(contentView)
        }
    }
}

// MARK: - DetailsActorsTableViewCell + UICollectionViewDataSource

extension DetailsActorsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        actors.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let actor = actors[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ActorCollectionViewCell.cellID,
            for: indexPath
        ) as? ActorCollectionViewCell else { return .init() }
        cell.configure(name: actor.name)
        if let url = actor.photoUrl {
            viewModel?.loadImage(with: url, completion: { data in
                guard let data else { return }
                cell.setImage(data: data)
            })
        }
        return cell
    }
}

// MARK: - DetailsActorsTableViewCell + UICollectionViewDelegateFlowLayout

extension DetailsActorsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 60, height: 97)
    }
}
