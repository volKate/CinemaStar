// ViewState.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Состояние загрузки данных
enum ViewState<T> {
    /// Загрузка не началась
    case initial
    /// Поисходит загрузка данных
    case loading
    /// Данные загружены
    case data(T)
    /// Данные не загружены
    case noData
    /// Ошибка при попытке запроса
    case error
}

extension ViewState: Equatable where T: Equatable {}
