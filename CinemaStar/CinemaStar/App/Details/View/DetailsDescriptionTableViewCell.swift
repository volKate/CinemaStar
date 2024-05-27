// DetailsDescriptionTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка описания фильма
final class DetailsDescriptionTableViewCell: UITableViewCell {
    // MARK: - Constants

    static let cellID = String(describing: DetailsDescriptionTableViewCell.self)

    // MARK: - Visual Components

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .inter(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 5
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

    func configure(description: String) {
        descriptionLabel.text = description
    }

    // MARK: - Private Methods

    private func setupCell() {
        contentView.addSubview(descriptionLabel)
        backgroundColor = .clear
        selectionStyle = .none
        setupConstraints()
    }

    private func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.leading.equalTo(contentView).inset(16)
            make.trailing.equalTo(contentView).inset(44)
        }
    }
}
