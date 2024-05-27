// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол сервиса запросов ресурсов
protocol NetworkServiceProtocol {
    /// Метод загрузки деталей о фильме
    func loadMovieDetails(id: Int, completion: @escaping (MovieDetails?) -> Void)
    /// Метод загрузки каталога фильмов
    func loadMovies(completion: @escaping ([MoviePreview]?) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    func loadMovieDetails(id: Int, completion: @escaping (MovieDetails?) -> Void) {
        let resource = MovieDetailsResource(id: id)
        let request = APIRequest(resource: resource)

        request.execute { movieDetailsDTO in
            _ = request
            DispatchQueue.main.async {
                guard let movieDetailsDTO else {
                    completion(nil)
                    return
                }
                let movieDetails = MovieDetails(fromDTO: movieDetailsDTO)
                completion(movieDetails)
            }
        }
    }

    func loadMovies(completion: @escaping ([MoviePreview]?) -> Void) {
        let resource = MoviesResource()
        let request = APIRequest(resource: resource)

        request.execute { moviesDTO in
            _ = request
            DispatchQueue.main.async {
                guard let moviesDTO else {
                    completion(nil)
                    return
                }
                let moviePreviews = moviesDTO.docs.map { MoviePreview(fromDTO: $0) }
                completion(moviePreviews)
            }
        }
    }
}
