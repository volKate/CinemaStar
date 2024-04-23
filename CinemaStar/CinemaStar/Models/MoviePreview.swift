// MoviePreview.swift
// Copyright © RoadMap. All rights reserved.

/// Превью фильма
struct MoviePreview: Identifiable {
    /// Идентификатор
    let id: Int
    /// Название
    let name: String
    /// Url постера
    let posterUrl: String
    /// Рейтинг на кинопоиске
    let kpRating: String

    init(fromDTO movieDTO: MovieDTO) {
        id = movieDTO.id
        name = movieDTO.name
        posterUrl = movieDTO.poster.url
        if let rating = movieDTO.rating?.kp {
            kpRating = "⭐ \(String(format: "%.1f", rating))"
        } else {
            kpRating = ""
        }
    }
}
