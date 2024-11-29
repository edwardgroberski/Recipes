//
//  RecipeAsyncImageViewModel.swift
//  Recipe
//
//  Created by Edward Groberski on 11/27/24.
//

import Foundation
import SwiftUI
import Dependencies

@Observable
final class RecipeAsyncImageViewModel: Sendable {
    private let photoUrl: URL?
    
    @MainActor
    private(set) var state: State = .idle
    
    init(photoUrl: URL?, runTask: Bool = true) {
        self.photoUrl = photoUrl
        if runTask {
            Task(priority: .background) {
                await loadImage()
            }
        }
    }
    
    func loadImage() async {
        guard let photoUrl else {
            print("RecipeAsyncImageViewModel - photoUrl is nil")
            await setPlaceholderState()
            return
        }
        
        if await isLoaded(){
            print("RecipeAsyncImageViewModel - already loaded")
            return
        }
        
        await setLoadingState()
        
        guard let key = photoUrl.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)?.uuidFromURLString() else {
            print("RecipeAsyncImageViewModel - invalid photoUrl")
            await setPlaceholderState()
            return
        }
        
        @Dependency(\.recipeImageCache) var recipeImageCache
        if let image = recipeImageCache.loadImage(for: key) {
            print("RecipeAsyncImageViewModel - load image from cache for \(key)")
            await setImageState(image)
        } else {
            await fetchImage(for: photoUrl, with: key)
        }
    }
    
    private func fetchImage(for url: URL, with key: String) async {
        @Dependency(\.apiClient) var apiClient
        let result = await apiClient.fetchData(url)
        switch result {
        case .success(let data):
            if let image = UIImage(data: data) {
                print("RecipeAsyncImageViewModel - image loaded from url for \(key)")
                await setImageState(image)
                
                @Dependency(\.recipeImageCache) var recipeImageCache
                recipeImageCache.saveImage(image, for: key)
            } else {
                print("RecipeAsyncImageViewModel - image failed to create for \(key)")
                await setPlaceholderState()
            }
        case .failure(_):
            print("RecipeAsyncImageViewModel - image load failed for \(key)")
            await setPlaceholderState()
        }
    }
}

// MARK: State Management

extension RecipeAsyncImageViewModel {
    @MainActor
    private func setLoadingState() {
        state = .loading
    }
    
    @MainActor
    private func setPlaceholderState() {
        state = .placeholder
    }
    
    @MainActor
    private func isLoaded() -> Bool {
        state.isLoaded
    }
    
    @MainActor
    private func setImageState(_ image: UIImage) {
        state = .loaded(image)
    }
}

extension RecipeAsyncImageViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded(UIImage)
        case placeholder
        
        var isLoaded: Bool {
            switch self {
            case .loaded: return true
            default: return false
            }
        }
    }
}
