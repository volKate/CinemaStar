// PreviewCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка превью фильма
final class PreviewCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    static let cellID = String(describing: PreviewCollectionViewCell.self)

    // MARK: - Visual Components

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(170)
            make.height.equalTo(200)
        }
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .inter(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    // MARK: - Public Methods

    func configure(name: String) {
        nameLabel.text = name
    }

    func setImage(data: Data) {
        posterImageView.image = UIImage(data: data)
    }

    // MARK: - Private Methods

    private func setupCell() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(posterImageView)
        setupConstraints()
    }

    private func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(nameLabel.snp.top).offset(-8)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(contentView)
        }
    }
}
