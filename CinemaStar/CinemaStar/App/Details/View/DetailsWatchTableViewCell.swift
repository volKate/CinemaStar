// DetailsWatchTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с кнопкой смотреть фильм
final class DetailsWatchTableViewCell: UITableViewCell {
    // MARK: - Constants

    static let cellID = String(describing: DetailsWatchTableViewCell.self)

    private enum Constants {
        static let buttonTitle = "Смотреть"
        static let cornerRadius = 12.0
        static let minHeight = 48.0
    }

    // MARK: - Visual Components

    private let watchButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .bgGreen
        button.layer.cornerRadius = Constants.cornerRadius
        button.clipsToBounds = true
        button.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(Constants.minHeight)
        }
        return button
    }()

    // MARK: - Private Properties

    private var viewModel: DetailsViewModelProtocol?

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

    func configure(viewModel: DetailsViewModelProtocol?) {
        self.viewModel = viewModel
    }

    // MARK: - Private Methods

    private func setupCell() {
        watchButton.addTarget(self, action: #selector(watchButtonTapped), for: .touchUpInside)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(watchButton)
        setupConstraints()
    }

    private func setupConstraints() {
        watchButton.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(16)
        }
    }

    @objc private func watchButtonTapped() {
        viewModel?.watchMovie()
    }
}
