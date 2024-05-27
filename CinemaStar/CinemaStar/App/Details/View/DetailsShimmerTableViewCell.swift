// DetailsShimmerTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка заглушка с шиммером экрана деталей
final class DetailsShimmerTableViewCell: UITableViewCell {
    // MARK: - Constants

    static let cellID = String(describing: DetailsShimmerTableViewCell.self)

    // MARK: - Visual Components

    private lazy var posterView = makePlaceholderView(height: 200, width: 170)
    private lazy var titleView = makePlaceholderView(height: 110)
    private lazy var buttonView = makePlaceholderView(height: 48)
    private lazy var descriptionView = makePlaceholderView(height: 100)
    private lazy var releaseInfoView = makePlaceholderView(width: 202)
    private lazy var actorsTitleView = makePlaceholderView(width: 202)
    private lazy var actorsView: UIStackView = {
        let stack = UIStackView()
        for _ in 1 ... 6 {
            stack.addArrangedSubview(makePlaceholderView(height: 97))
        }
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var languageTitleView = makePlaceholderView(width: 202)
    private lazy var languageView = makePlaceholderView(width: 202)
    private lazy var recommendationsTitleView = makePlaceholderView(width: 202)
    private lazy var recommendationView = makePlaceholderView(height: 200, width: 170)
    private lazy var recommendationNameView = makePlaceholderView(width: 202)

    // MARK: - Private Properties

    private var placeholderViews: [UIView] {
        [
            posterView,
            titleView,
            buttonView,
            descriptionView,
            releaseInfoView,
            actorsTitleView,
            actorsView,
            languageTitleView,
            languageView,
            recommendationsTitleView,
            recommendationView,
            recommendationNameView
        ]
    }

    private var shimmeredViews: [UIView] {
        placeholderViews.map { view in
            guard let stackView = view as? UIStackView else { return [view] }
            return stackView.arrangedSubviews
        }.flatMap { $0 }
    }

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        for view in shimmeredViews {
            view.layoutIfNeeded()
            let shimmerLayer = ShimmerLayer()
            view.layer.addSublayer(shimmerLayer)
            shimmerLayer.frame = view.bounds
        }
    }

    // MARK: - Private Methods

    private func setupCell() {
        for placeholderView in placeholderViews {
            contentView.addSubview(placeholderView)
        }
        backgroundColor = .clear
        selectionStyle = .none
        setupConstraints()
    }

    private func setupConstraints() {
        posterView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(16)
            make.trailing.equalTo(titleView.snp.leading).offset(-16)
        }

        titleView.snp.makeConstraints { make in
            make.centerY.equalTo(posterView)
            make.trailing.equalTo(contentView).inset(16)
        }

        buttonView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(16)
            make.top.equalTo(posterView.snp.bottom).offset(16)
        }

        descriptionView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.trailing.equalTo(contentView).inset(44)
            make.top.equalTo(buttonView.snp.bottom).inset(-16)
        }

        releaseInfoView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.top.equalTo(descriptionView.snp.bottom).offset(10)
        }

        actorsTitleView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.top.equalTo(releaseInfoView.snp.bottom).offset(16)
        }

        actorsView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.trailing.equalTo(contentView).inset(-22)
            make.top.equalTo(actorsTitleView.snp.bottom).offset(10)
        }

        languageTitleView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.top.equalTo(actorsView.snp.bottom).offset(14)
        }

        languageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.top.equalTo(languageTitleView.snp.bottom).offset(4)
        }

        recommendationsTitleView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.top.equalTo(languageView.snp.bottom).offset(10)
        }

        recommendationView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.top.equalTo(recommendationsTitleView.snp.bottom).offset(8)
        }

        recommendationNameView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.top.equalTo(recommendationView.snp.bottom).offset(8)
            make.bottom.equalTo(contentView)
        }
    }

    private func makePlaceholderView(height: CGFloat = 20, width: CGFloat? = nil) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        view.snp.makeConstraints { make in
            make.height.equalTo(height)
            if let width {
                make.width.equalTo(width)
            }
        }
        return view
    }
}
