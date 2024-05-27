// TokenStorage.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import Keychain

/// Протокол хранилища токена
protocol TokenStorageProtocol {
    /// Метод запрашивающий токен
    func getToken() throws -> String
}

/// Класс хранилище апи токена
final class TokenStorage: TokenStorageProtocol {
    /// Ошибки запроса токена
    enum TokenError: Error {
        /// Токен не найден
        case notFound
    }

    private enum Constants {
        static let tokenEnvKey = "TOKEN"
        static let tokenKeychainKey = "token"
    }

    private let keychain = Keychain()

    func getToken() throws -> String {
        guard let token = keychain.value(forKey: Constants.tokenKeychainKey) as? String else {
            guard let envToken = ProcessInfo.processInfo.environment[Constants.tokenEnvKey] else {
                throw TokenError.notFound
            }
            _ = keychain.save(envToken, forKey: Constants.tokenKeychainKey)
            return envToken
        }
        return token
    }
}
