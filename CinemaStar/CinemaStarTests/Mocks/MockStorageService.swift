// MockStorageService.swift
// Copyright © RoadMap. All rights reserved.

@testable import CinemaStar
import Foundation

/// Мок сервиса хранения данных
final class MockStorageService: Storage {
    private(set) var storeArray: [Codable] = []
    func save(_ value: Codable, forKey key: String) throws {
        storeArray.append(value)
    }

    func value<T: Codable>(forKey key: String) throws -> T {
        guard let value = storeArray.last as? T else { throw StorageError.notFound }
        return value
    }
}
