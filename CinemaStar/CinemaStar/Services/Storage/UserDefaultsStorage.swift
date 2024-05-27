// UserDefaultsStorage.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Хранилище UserDefaults
struct UserDefaultsStorage: Storage {
    private let userDefaults = UserDefaults.standard

    func save(_ value: Codable, forKey key: String) throws {
        let encodedData = try JSONEncoder().encode(value)
        userDefaults.set(encodedData, forKey: key)
    }

    func value<T: Codable>(forKey key: String) throws -> T {
        if let savedData = userDefaults.object(forKey: key) as? Data {
            return try JSONDecoder().decode(T.self, from: savedData)
        }
        throw StorageError.notFound
    }
}
