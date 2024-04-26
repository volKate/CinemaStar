// MovieShimmerCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка заглушка с шиммером для фильма в каталоге
final class MovieShimmerCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    static let cellID = String(describing: MovieShimmerCollectionViewCell.self)

    // MARK: - Visual Components

    private lazy var posterView = makePlaceholderView(height: 200)
    private lazy var nameView = makePlaceholderView()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        for view in [posterView, nameView] {
            view.layoutIfNeeded()
            let shimmerLayer = ShimmerLayer()
            view.layer.addSublayer(shimmerLayer)
            shimmerLayer.frame = view.bounds
        }
    }

    // MARK: - Private Methods

    private func setupCell() {
        contentView.addSubview(posterView)
        contentView.addSubview(nameView)
        setupConstraints()
    }

    private func setupConstraints() {
        posterView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
        }

        nameView.snp.makeConstraints { make in
            make.top.equalTo(posterView.snp.bottom).offset(8)
            make.bottom.equalTo(contentView)
            make.leading.trailing.equalTo(contentView)
        }
    }

    private func makePlaceholderView(height: CGFloat? = nil, width: CGFloat? = nil) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        view.snp.makeConstraints { make in
            if let height {
                make.height.equalTo(height)
            }
            if let width {
                make.width.equalTo(width)
            }
        }
        return view
    }
}
