// MockNetworkService.swift
// Copyright © RoadMap. All rights reserved.

@testable import CinemaStar
import Foundation

/// Мок сервиса загрузки данных сети
final class MockNetworkService: NetworkServiceProtocol {
    var shouldResultWithError = false
    let expectedMovies: [MoviePreview] = [MockObjects.mockMoviePreview]
    let expectedMovieDetails: MovieDetails = MockObjects.mockMovieDetails

    func loadMovieDetails(id: Int, completion: @escaping (MovieDetails?) -> Void) {
        if shouldResultWithError {
            completion(nil)
            return
        }
        completion(expectedMovieDetails)
    }

    func loadMovies(completion: @escaping ([MoviePreview]?) -> Void) {
        if shouldResultWithError {
            completion(nil)
            return
        }
        completion(expectedMovies)
    }
}
