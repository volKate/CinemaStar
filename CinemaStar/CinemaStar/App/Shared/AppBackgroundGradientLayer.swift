// AppBackgroundGradientLayer.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Универсальный градиент фон приложения
final class AppBackgroundGradientLayer: CAGradientLayer {
    // MARK: - Initializers

    init(frame: CGRect) {
        super.init()
        setColors()
        self.frame = frame
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setColors()
    }

    // MARK: - Private Methods

    private func setColors() {
        colors = [UIColor.bgBrown.cgColor, UIColor.bgGreen.cgColor]
    }
}
