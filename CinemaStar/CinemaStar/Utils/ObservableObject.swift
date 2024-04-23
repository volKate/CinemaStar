// ObservableObject.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Класс обертка для отслеживания изменения значения
final class ObservableObject<T> {
    var value: T {
        didSet {
            bindings.forEach { $0(value) }
        }
    }

    private var bindings: [(T) -> Void] = []

    init(value: T) {
        self.value = value
    }

    func bind(_ binding: @escaping (T) -> Void) {
        binding(value)
        bindings.append(binding)
    }
}
