//
//  RecipeImageCache.swift
//  Recipe
//
//  Created by Edward Groberski on 11/27/24.
//

import Foundation
import SwiftUI
import Dependencies

protocol RecipeImageCacheProtocol: Sendable {
    func image(from url: URL) async throws -> UIImage?
}

actor RecipeImageCache: RecipeImageCacheProtocol {
    private let cacheDirectory: URL
    
    private enum CacheEntry {
        case inProgress(Task<UIImage, Error>)
        case ready(UIImage)
        case error
    }
    
    private var cache: [URL: CacheEntry] = [:]
    
    private enum RecipeImageCacheError: Error {
        case imageRequestFailure
        case imageDiskFailure
    }
    
    init() {
        @Dependency(\.fileCacheManager) var fileCacheManager
        cacheDirectory = try! fileCacheManager.createCacheDirectory("ImageCache")
    }
    
    func image(from url: URL) async throws -> UIImage? {
        if let cached = cache[url] {
            switch cached {
            case .ready(let image):
                return image
            case .inProgress(let task):
                return try await task.value
            case .error:
                return nil
            }
        }
        
        let task = Task {
            try await fetchImage(for: url)
        }
        
        cache[url] = .inProgress(task)
        
        do {
            let image = try await task.value
            cache[url] = .ready(image)
            return image
        } catch {
            cache[url] = .error
            return nil
        }
    }
    
    private func fetchImage(for url: URL) async throws -> UIImage {
        guard let key = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)?.uuidFromURLString() else {
            print("RecipeImageCache - invalid photoUrl for \(url)")
            throw RecipeImageCacheError.imageRequestFailure
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(key)
        do {
            @Dependency(\.dataWriter) var dataWriter
            let data = try dataWriter.read(fileURL)
            if let image = UIImage(data: data) {
                print("RecipeImageCache - load image from disk for \(url)")
                return image
            } else {
                print("RecipeImageCache - failed load image from disk for \(url)")
                throw RecipeImageCacheError.imageDiskFailure
            }
        } catch {
            @Dependency(\.apiClient) var apiClient
            let result = await apiClient.fetchData(url)
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    Task.detached {
                        @Dependency(\.dataWriter) var dataWriter
                        try? dataWriter.write(data, fileURL)
                        print("RecipeImageCache - write image to disk for \(url)")
                    }
                    
                    print("RecipeImageCache - load image from url for \(url)")
                    
                    return image
                } else {
                    throw RecipeImageCacheError.imageRequestFailure
                }
            case .failure(_):
                print("RecipeImageCache - failed load image from url for \(url)")
                throw RecipeImageCacheError.imageRequestFailure
            }
        }
    }
}

enum RecipeImageCacheKey: DependencyKey {
    static let liveValue: RecipeImageCacheProtocol = RecipeImageCache()
        static let testValue: RecipeImageCacheProtocol = MockRecipeImageCache()
        static let previewValue: RecipeImageCacheProtocol = MockRecipeImageCache()
        static let failureValue: RecipeImageCacheProtocol = MockRecipeImageCache(returnImage: false)
}

extension DependencyValues {
    var recipeImageCache: RecipeImageCacheProtocol {
        get { self[RecipeImageCacheKey.self] }
        set { self[RecipeImageCacheKey.self] = newValue }
    }
}


final class MockRecipeImageCache: RecipeImageCacheProtocol {
    private let returnImage: Bool
    
    init(returnImage: Bool = true) {
        self.returnImage = returnImage
    }
    
    func image(from url: URL) async throws -> UIImage? {
        if returnImage {
            return foodImage
        } else {
            return nil
        }
    }
}
