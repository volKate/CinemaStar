// Actor.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Актер фильма
struct Actor: Identifiable {
    /// Идентификатор
    let id: Int
    /// Url фотографии
    let photoUrl: URL?
    /// Имя
    let name: String

    init(fromDTO actorDTO: PersonDTO) {
        id = actorDTO.id
        photoUrl = URL(string: actorDTO.photo)
        name = actorDTO.name ?? actorDTO.enName ?? ""
    }
}
