// MoviePreview.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Превью фильма
struct MoviePreview: Identifiable {
    /// Идентификатор
    let id: Int
    /// Название
    let name: String
    /// Url постера
    let posterUrl: URL?
    /// Рейтинг на кинопоиске
    let kpRating: String

    init(fromDTO movieDTO: MoviePreviewDTO) {
        id = movieDTO.id
        name = movieDTO.name
        posterUrl = URL(string: movieDTO.poster.url)
        if let rating = movieDTO.rating?.kp {
            kpRating = "⭐ \(String(format: "%.1f", rating))"
        } else {
            kpRating = ""
        }
    }
}

// MARK: - MoviePreview + Equatable

extension MoviePreview: Equatable {
    static func == (lhs: MoviePreview, rhs: MoviePreview) -> Bool {
        lhs.id == rhs.id
    }
}
