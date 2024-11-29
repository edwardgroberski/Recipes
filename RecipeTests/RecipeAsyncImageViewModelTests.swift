//
//  RecipeAsyncImageViewModelTests.swift
//  RecipeTests
//
//  Created by Edward Groberski on 11/29/24.
//

import Testing
import Dependencies
import Foundation
import UIKit
@testable import Recipe

struct RecipeAsyncImageViewModelTests {
    
    struct LoadImage {
        
        struct PlaceholderState {
            @MainActor
            @Test func whenPhotoURLIsNil() async throws {
                await withDependencies {
                    $0.recipeImageCache = RecipeImageCacheKey.testValue
                    $0.apiClient = .validImageDataValue
                } operation: {
                    let viewModel = RecipeAsyncImageViewModel(photoUrl: nil, runTask: false)
                    await viewModel.loadImage()
                    #expect(viewModel.state == .placeholder)
                }
            }
            
            @MainActor
            @Test func whenFetchingImageFails() async throws {
                await withDependencies {
                    $0.recipeImageCache = RecipeImageCacheKey.failureValue
                    $0.apiClient = .failureValue
                } operation: {
                    let viewModel = RecipeAsyncImageViewModel(photoUrl: URL(fileURLWithPath: ""), runTask: false)
                    await viewModel.loadImage()
                    #expect(viewModel.state == .placeholder)
                }
            }
        }
        
        struct LoadedState {
            @MainActor
            @Test func whenImageCacheReturnsImage() async throws {
                await withDependencies {
                    $0.recipeImageCache = RecipeImageCacheKey.testValue
                    $0.apiClient = .failureValue
                } operation: {
                    let viewModel = RecipeAsyncImageViewModel(photoUrl: URL(fileURLWithPath: ""), runTask: false)
                    await viewModel.loadImage()
                    #expect(viewModel.state.isLoaded)
                }
            }
            
            @MainActor
            @Test func whenFetchImageReturnsImage() async throws {
               await withDependencies {
                    $0.recipeImageCache = RecipeImageCacheKey.failureValue
                    $0.apiClient = .validImageDataValue
                } operation: {
                    let viewModel = RecipeAsyncImageViewModel(photoUrl: URL(fileURLWithPath: ""), runTask: false)
                    await viewModel.loadImage()
                    #expect(viewModel.state.isLoaded)
                }
            }
        }
    }
}
