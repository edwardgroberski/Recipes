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
            Task.detached(priority: .background) {
                await self.loadImage()
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
        
        @Dependency(\.recipeImageCache) var recipeImageCache
        if let image = try? await recipeImageCache.image(from: photoUrl) {
            print("RecipeAsyncImageViewModel - image loaded")
            await setImageState(image)
        } else {
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
