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
    @discardableResult func saveImage(_ image: UIImage, for key: String) -> Bool
    func loadImage(for key: String) -> UIImage?
}

final class RecipeImageCache: RecipeImageCacheProtocol {
    private let cacheDirectory: URL
    
    init() {
        @Dependency(\.fileCacheManager) var fileCacheManager
        cacheDirectory = try! fileCacheManager.createCacheDirectory("ImageCache")
    }
    
    @discardableResult
    func saveImage(_ image: UIImage, for key: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) else { return false }
        let fileURL = cacheDirectory.appendingPathComponent(key)
        
        do {
            @Dependency(\.dataWriter) var dataWriter
            try dataWriter.write(data, fileURL)
            print("RecipeImageCache - save image for \(key)")
            return true
        } catch {
            print("RecipeImageCache - save image for \(key) - error: \(error) ")
            return false
        }
    }
    
    func loadImage(for key: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        do {
            @Dependency(\.dataWriter) var dataWriter
            let data = try dataWriter.read(fileURL)
            print("RecipeImageCache - load image for \(key)")
            return UIImage(data: data)
        } catch {
            print("RecipeImageCache - load image for \(key) - error: \(error)")
            return nil
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
    
    @discardableResult func saveImage(_ image: UIImage, for key: String) -> Bool {
        returnImage
    }
    
    func loadImage(for key: String) -> UIImage? {
        if returnImage {
            return foodImage
        } else {
            return nil
        }
    }
}
