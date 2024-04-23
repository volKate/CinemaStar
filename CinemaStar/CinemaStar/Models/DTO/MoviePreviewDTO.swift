// MoviePreviewDTO.swift
// Copyright © RoadMap. All rights reserved.

/// Фильм
struct MoviePreviewDTO: Decodable {
    /// Идентификатор
    let id: Int
    /// Название
    let name: String
    /// Данные о постере
    let poster: PosterDTO
    /// Данные о рейтинге
    let rating: RatingDTO?
}
