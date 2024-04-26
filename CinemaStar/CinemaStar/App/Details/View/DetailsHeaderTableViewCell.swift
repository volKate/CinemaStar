// DetailsHeaderTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import SnapKit
import UIKit

/// Ячейка шапки деталей
final class DetailsHeaderTableViewCell: UITableViewCell {
    // MARK: - Constants

    static let cellID = String(describing: DetailsHeaderTableViewCell.self)

    private enum Constants {
        static let posterCornerRadius = 8.0
        static let posterSize = CGSize(width: 170, height: 200)
    }

    // MARK: - Visual Components

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.posterCornerRadius
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints { make in
            make.width.equalTo(Constants.posterSize.width)
            make.height.greaterThanOrEqualTo(Constants.posterSize.height)
            make.height.lessThanOrEqualTo(Constants.posterSize.height + 5)
        }
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .interBold(ofSize: 18)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .inter(ofSize: 16)
        label.textColor = .white
        return label
    }()

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

    func configure(title: String, rating: String) {
        titleLabel.text = title
        ratingLabel.text = rating
    }

    func setImage(data: Data) {
        posterImageView.image = UIImage(data: data)
    }

    // MARK: - Private Methods

    private func setupCell() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingLabel)
        selectionStyle = .none
        backgroundColor = .clear
        setupConstraints()
    }

    private func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(20)
            make.leading.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView)
            make.trailing.equalTo(titleLabel.snp.leading).offset(-16)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(posterImageView)
            make.trailing.equalTo(contentView).inset(16)
        }

        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.trailing.equalTo(titleLabel)
        }
    }
}
