// MovieDetails.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Детали фильма
struct MovieDetails: Identifiable {
    enum MovieType: String {
        case series = "tv-series"
        case movie

        func stringValue() -> String {
            switch self {
            case .series:
                return "Сериал"
            case .movie:
                return "Фильм"
            }
        }
    }

    /// Идентификатор
    let id: Int
    /// Название
    let name: String
    /// Url постера
    let posterUrl: URL?
    /// Рейтинг на кинопоиске
    let kpRating: String
    /// Описание
    let description: String
    /// Информация о релизе
    let releaseInfo: String
    /// Актеры
    let actors: [Actor]
    /// Язык картины
    let language: String?
    /// Похожие фильмы
    let similarMovies: [MoviePreview]?

    init(
        id: Int,
        name: String,
        posterUrl: String,
        kpRating: String,
        description: String,
        releaseInfo: String,
        actors: [Actor],
        language: String?,
        similarMovies: [MoviePreview]?
    ) {
        self.id = id
        self.name = name
        self.posterUrl = URL(string: posterUrl)
        self.kpRating = kpRating
        self.description = description
        self.releaseInfo = releaseInfo
        self.actors = actors
        self.language = language
        self.similarMovies = similarMovies
    }

    init(fromDTO movieDTO: MovieDetailsDTO) {
        id = movieDTO.id
        name = movieDTO.name
        posterUrl = URL(string: movieDTO.poster.url)
        kpRating = "⭐ \(String(format: "%.1f", movieDTO.rating.kp))"
        description = movieDTO.description
        releaseInfo = [
            String(movieDTO.year),
            movieDTO.countries.first?.name,
            MovieType(rawValue: movieDTO.type)?.stringValue()
        ].compactMap { $0 }.joined(separator: " / ")
        actors = movieDTO.persons.map { Actor(fromDTO: $0) }
        language = movieDTO.spokenLanguages?.first?.name
        similarMovies = movieDTO.similarMovies?.map { MoviePreview(fromDTO: $0) }
    }
}
