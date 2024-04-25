// UIFont+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Расширение для шрифта Inter
extension UIFont {
    /// Шрифт inter с жирностью 400
    /// - Parameter ofSize: размер шрифта
    /// - Returns: опциональный шрифт inter
    static func inter(ofSize size: CGFloat) -> UIFont? {
        UIFont(name: "Inter-Regular", size: size)
    }

    /// Шрифт inter с жирностью 600
    /// - Parameter ofSize: размер шрифта
    /// - Returns: опциональный жирный шрифт inter
    static func interBold(ofSize size: CGFloat) -> UIFont? {
        UIFont(name: "Inter-SemiBold", size: size)
    }

    /// Шрифт inter с жирностью 900
    /// - Parameter ofSize: размер шрифта
    /// - Returns: опциональный жирный шрифт inter
    static func interBlack(ofSize size: CGFloat) -> UIFont? {
        UIFont(name: "Inter-Black", size: size)
    }
}
