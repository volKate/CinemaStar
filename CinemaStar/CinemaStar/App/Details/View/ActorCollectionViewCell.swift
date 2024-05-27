// ActorCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка информации об актере
final class ActorCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    static let cellID = String(describing: ActorCollectionViewCell.self)

    // MARK: - Visual Components

    private let actorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints { make in
            make.width.equalTo(46)
            make.height.equalTo(72)
        }
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .inter(ofSize: 8)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
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
        actorImageView.image = UIImage(data: data)
    }

    // MARK: - Private Methods

    private func setupCell() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(actorImageView)
        setupConstraints()
    }

    private func setupConstraints() {
        actorImageView.snp.makeConstraints { make in
            make.top.centerX.equalTo(contentView)
            make.bottom.equalTo(nameLabel.snp.top)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(contentView)
        }
    }
}
