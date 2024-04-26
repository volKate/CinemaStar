// DetailsLanguageTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка сведений о языке фильма
final class DetailsLanguageTableViewCell: UITableViewCell {
    // MARK: - Constants

    static let cellID = String(describing: DetailsLanguageTableViewCell.self)

    private enum Constants {
        static let title = "Язык"
    }

    // MARK: - Visual Components

    private let languageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .interBold(ofSize: 14)
        label.textColor = .white
        label.text = Constants.title
        return label
    }()

    private let languageLabel: UILabel = {
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

    func configure(language: String) {
        languageLabel.text = language
    }

    // MARK: - Private Methods

    private func setupCell() {
        contentView.addSubview(languageTitleLabel)
        contentView.addSubview(languageLabel)
        backgroundColor = .clear
        selectionStyle = .none
        setupConstraints()
    }

    private func setupConstraints() {
        languageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(14)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(languageLabel.snp.top).offset(-4)
        }

        languageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(languageTitleLabel)
            make.bottom.equalTo(contentView).inset(10)
        }
    }
}
