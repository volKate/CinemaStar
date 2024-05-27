// PersonDTO.swift
// Copyright © RoadMap. All rights reserved.

/// Актер
struct PersonDTO: Decodable {
    /// Идентификатор
    let id: Int
    /// Url фотографии
    let photo: String
    /// Имя
    let name: String?
    /// Иностранное имя
    let enName: String?
}
