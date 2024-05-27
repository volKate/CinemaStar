// WrapperDTO.swift
// Copyright © RoadMap. All rights reserved.

/// Обертка содержащая список фильмов
struct WrapperDTO: Decodable {
    /// Список фильмов
    let docs: [MoviePreviewDTO]
}
