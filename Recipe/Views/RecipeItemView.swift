//
//  RecipeItemView.swift
//  Recipe
//
//  Created by Edward Groberski on 11/26/24.
//

import SwiftUI

struct RecipeItemView: View {
    private let viewModel: RecipeItemViewModel
    
    init(viewModel: RecipeItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.title2)
                Text(viewModel.cuisine)
                    .font(.subheadline)
            }
            Spacer()
            RecipeAsyncImage(viewModel: RecipeAsyncImageViewModel(photoUrl: viewModel.photoURL))
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 10)
    }
}

#Preview {
    RecipeItemView(viewModel: RecipeItemViewModel(recipe: recipe1))
}
