// LoadImageService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

///
protocol LoadImageServiceProtocol {
    func load(with url: URL, completion: @escaping (Data?) -> Void)
}

///
final class LoadImageService: LoadImageServiceProtocol {
    func load(with url: URL, completion: @escaping (Data?) -> Void) {
        let request = ImageRequest(url: url)
        request.execute { data in
            let request = request
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
}
