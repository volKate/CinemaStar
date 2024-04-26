// LoadImageService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол сервиса загрузки изображений
protocol LoadImageServiceProtocol {
    /// Метод загрузки изображения
    func load(with url: URL, completion: @escaping (Data?) -> Void)
}

/// Сервис загрузки изображений
final class LoadImageService: LoadImageServiceProtocol {
    func load(with url: URL, completion: @escaping (Data?) -> Void) {
        let request = ImageRequest(url: url)
        request.execute { data in
            _ = request
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
}

/// Прокси для получения и кэширования изображений
final class LoadImageProxy: LoadImageServiceProtocol {
    private var service: LoadImageServiceProtocol

    init(service: LoadImageServiceProtocol) {
        self.service = service
    }

    func load(with url: URL, completion: @escaping (Data?) -> Void) {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            return
        }

        let stringHash = String(url.relativePath.hashValue)
        let imageUrl = documentsDirectory.appendingPathComponent(stringHash)
        if fileManager.fileExists(atPath: imageUrl.path) {
            let imageData = try? Data(contentsOf: imageUrl)
            completion(imageData)
        } else {
            service.load(with: url) { data in
                if let data = data {
                    do {
                        try data.write(to: imageUrl)
                        completion(data)
                    } catch {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }
}
