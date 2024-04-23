// Actor.swift
// Copyright © RoadMap. All rights reserved.

/// Актер фильма
struct Actor: Identifiable {
    /// Идентификатор
    let id: Int
    /// Url фотографии
    let photoUrl: String
    /// Имя
    let name: String

    init(fromDTO actorDTO: PersonDTO) {
        id = actorDTO.id
        photoUrl = actorDTO.photo
        name = actorDTO.name
    }
}
