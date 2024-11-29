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
    
    struct SaveImage {
        @Test func successful() async throws {
            let imageCache = withDependencies {
                $0.fileCacheManager = .testValue
                $0.dataWriter = .testValue
            } operation: {
                RecipeImageCache()
            }
            let image = UIImage(systemName: "fork.knife.circle.fill")!
            
            let result = imageCache.saveImage(image, for: "")
            #expect(result)
        }
        
        @Test func failure() async throws {
            let result = withDependencies {
                $0.fileCacheManager = .testValue
                $0.dataWriter = .failureValue
            } operation: {
                let image = UIImage(systemName: "fork.knife.circle.fill")!
                let imageCache = RecipeImageCache()
                return imageCache.saveImage(image, for: "")
            }
            #expect(!result)
        }
    }

    struct LoadImage {
        @Test func successful() async throws {
            let imageCache = withDependencies {
                $0.fileCacheManager = .testValue
                $0.dataWriter = .testValue
            } operation: {
                RecipeImageCache()
            }
            let result = imageCache.loadImage(for: "")
            #expect(result != nil)
        }
        
        @Test func failure() async throws {
            let result = withDependencies {
                $0.fileCacheManager = .testValue
                $0.dataWriter = .failureValue
            } operation: {
                let imageCache = RecipeImageCache()
                return imageCache.loadImage(for: "")
            }
            #expect(result == nil)
        }
    }
}
