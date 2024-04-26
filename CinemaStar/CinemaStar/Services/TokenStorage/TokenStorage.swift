// TokenStorage.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import Keychain

/// Протокол хранилища токена
protocol TokenStorageProtocol {
    func getToken() throws -> String
}

/// Класс хранилище апи токена
final class TokenStorage: TokenStorageProtocol {
    enum TokenError: Error {
        case notFound
    }

    private let tokenEnvKey = "TOKEN"
    private let tokenKeychainKey = "token"
    private let keychain = Keychain()

    func getToken() throws -> String {
        guard let token = keychain.value(forKey: tokenKeychainKey) as? String else {
            guard let envToken = ProcessInfo.processInfo.environment[tokenEnvKey] else {
                throw TokenError.notFound
            }
            _ = keychain.save(envToken, forKey: tokenKeychainKey)
            return envToken
        }
        return token
    }
}
