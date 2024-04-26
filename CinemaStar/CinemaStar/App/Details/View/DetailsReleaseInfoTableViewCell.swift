// DetailsReleaseInfoTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка информации о релизе фильма
final class DetailsReleaseInfoTableViewCell: UITableViewCell {
    // MARK: - Constants

    static let cellID = String(describing: DetailsReleaseInfoTableViewCell.self)

    // MARK: - Visual Components

    private let releaseInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .inter(ofSize: 14)
        label.textColor = UIColor(white: 0, alpha: 0.41)
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

    func configure(releaseInfo: String) {
        releaseInfoLabel.text = releaseInfo
    }

    // MARK: - Private Methods

    private func setupCell() {
        contentView.addSubview(releaseInfoLabel)
        backgroundColor = .clear
        selectionStyle = .none
        setupConstraints()
    }

    private func setupConstraints() {
        releaseInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(10)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView).inset(16)
        }
    }
}
