// MovieDetailsDTO.swift
// Copyright © RoadMap. All rights reserved.

/// DTO деталей фильма
struct MovieDetailsDTO: Decodable {
    /// Идентификатор
    let id: Int
    /// Название
    let name: String
    /// Данные о постере
    let poster: PosterDTO
    /// Данные о рейтинге
    let rating: RatingDTO
    /// Описание
    let description: String
    /// Год выпуска
    let year: Int
    /// Страны выпуска
    let countries: [CountryDTO]
    /// Тип картины (фильм/сериал)
    let type: String
    /// Актеры
    let persons: [PersonDTO]
    /// Языки фильма
    let spokenLanguages: [LanguageDTO]?
    /// Похожие фильмы
    let similarMovies: [MoviePreviewDTO]?
}
