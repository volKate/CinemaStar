// Movie.swift
// Copyright © RoadMap. All rights reserved.

/// Детали фильма
struct Movie: Identifiable {
    enum MovieType: String {
        case series = "tv-series"
        case movie
    }

    /// Идентификатор
    let id: Int
    /// Название
    let name: String
    /// Url постера
    let posterUrl: String
    /// Рейтинг на кинопоиске
    let kpRating: Double?
    /// Описание
    let description: String
    /// Год выпуска
    let releaseYear: Int
    /// Страна выпуска
    let countryOfOrigin: String?
    /// Тип картины (фильм/сериал)
    let type: MovieType?
    /// Актеры
    let actors: [Actor]
    /// Язык картины
    let language: String?
    /// Похожие фильмы
    let similarMovies: [MoviePreview]?

    init(fromDTO movieDTO: MovieDetailsDTO) {
        id = movieDTO.id
        name = movieDTO.name
        posterUrl = movieDTO.poster.url
        kpRating = movieDTO.rating.kp
        description = movieDTO.description
        releaseYear = movieDTO.year
        countryOfOrigin = movieDTO.countries.first?.name
        type = MovieType(rawValue: movieDTO.type)
        actors = movieDTO.persons.map { Actor(fromDTO: $0) }
        language = movieDTO.spokenLanguages?.first?.name
        similarMovies = movieDTO.similarMovies?.map { MoviePreview(fromDTO: $0) }
    }
}
