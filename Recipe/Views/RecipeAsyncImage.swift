//
//  RecipeAsyncImage.swift
//  Recipe
//
//  Created by Edward Groberski on 11/27/24.
//

import SwiftUI
import Dependencies

struct RecipeAsyncImage: View {
    private let viewModel: RecipeAsyncImageViewModel
    
    init(viewModel: RecipeAsyncImageViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading, .idle:
                loadingView
            case .loaded(let image):
                loadedView(image)
            case .placeholder:
                placeholder
            }
        }
        .frame(height: 100)
        .padding(8)
    }
    
    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(1.5)
            .padding()
    }
    
    @ViewBuilder
    private func loadedView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
    }
    
    private var placeholder: some View {
        Image(systemName: "fork.knife.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(height: 100)
            .cornerRadius(10)
    }
}

#Preview("Loaded Image") {
    RecipeAsyncImage(viewModel: withDependencies {
        $0.recipeImageCache = RecipeImageCacheKey.previewValue
    } operation: {
        RecipeAsyncImageViewModel(photoUrl: URL(fileURLWithPath: ""))
    })
}

#Preview("Placeholder Image") {
    RecipeAsyncImage(viewModel: withDependencies {
        $0.recipeImageCache = RecipeImageCacheKey.previewValue
    } operation: {
        RecipeAsyncImageViewModel(photoUrl: nil)
    })
}
