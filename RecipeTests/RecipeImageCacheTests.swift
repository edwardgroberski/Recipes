//
//  RecipeImageCacheTests.swift
//  RecipeTests
//
//  Created by Edward Groberski on 11/29/24.
//

import Testing
import Dependencies
import Foundation
import UIKit
@testable import Recipe

struct RecipeImageCacheTests {
    private let url = URL(string: "https://google.com")!
    
    @Test func successfulLoadImageFromDisk() async throws {
        let result = try await withDependencies {
            $0.fileCacheManager = .testValue
            $0.dataWriter = .testValue
        } operation: {
            let imageCache = RecipeImageCache()
            return try await imageCache.image(from: url)
        }
        
        #expect(result != nil)
    }
    
    @Test func successfulLoadImageFromURL() async throws {
        let result = try await withDependencies {
            $0.fileCacheManager = .testValue
            $0.dataWriter = .failureValue
            $0.apiClient = .validImageDataValue
        } operation: {
            let imageCache = RecipeImageCache()
            return try await imageCache.image(from: url)
        }
        
        #expect(result != nil)
    }
    
    @Test func failureLoadImageFromDiskAndURL() async throws {
        let result = try await withDependencies {
            $0.fileCacheManager = .testValue
            $0.dataWriter = .failureValue
            $0.apiClient = .failureValue
        } operation: {
            let imageCache = RecipeImageCache()
            return try await imageCache.image(from: url)
        }
        
        #expect(result == nil)
    }
}
