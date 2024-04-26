// Storage.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Ошибки при работе с хранилищем
enum StorageError: Error {
    /// Значение по ключу не найдено
    case notFound
}

/// Протокол хранилища кодируемых данных
protocol Storage {
    /// Метод сохранения данных по ключу
    func save(_ value: Codable, forKey key: String) throws
    /// Метод получения данных по ключу
    func value<T: Codable>(forKey key: String) throws -> T
}
