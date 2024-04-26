// ShimmerLayer.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Слой градиента с анимацией шиммера
final class ShimmerLayer: CAGradientLayer {
    // MARK: - Public Properties

    let clearColor: UIColor

    // MARK: - Initializers

    init(clearColor: UIColor = .clear) {
        self.clearColor = clearColor
        super.init()
        setupLayer()
        setupAnimation()
    }

    required init?(coder: NSCoder) {
        clearColor = .clear
        super.init(coder: coder)
    }

    // MARK: - Private Methods

    private func setupLayer() {
        startPoint = CGPoint(x: 0, y: 1)
        endPoint = CGPoint(x: 1, y: 1)
        colors = [
            UIColor.grayShimmer.cgColor,
            clearColor.cgColor,
            UIColor.grayShimmer.cgColor,
            clearColor.cgColor
        ]
        locations = [-2, -1, 0, 1]
    }

    private func setupAnimation() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-2, -1, 0, 1]
        animation.toValue = [0, 1, 2, 3]
        animation.repeatCount = .infinity
        animation.duration = 1.2
        add(animation, forKey: animation.keyPath)
    }
}
