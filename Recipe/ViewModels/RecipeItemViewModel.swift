//
//  RecipeItemViewModel.swift
//  Recipe
//
//  Created by Edward Groberski on 11/26/24.
//

import Foundation

class RecipeItemViewModel: Identifiable, Equatable {
    private let recipe: Recipe
    
    var name: String {
        recipe.name
    }
    
    var cuisine: String {
        recipe.cuisine
    }
    
    var photoURL: URL? {
        guard let photoUrlSmall = recipe.photoUrlSmall else {
            return nil
        }
        
        return URL(string: photoUrlSmall)
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    static func == (lhs: RecipeItemViewModel, rhs: RecipeItemViewModel) -> Bool {
        lhs.recipe == rhs.recipe
    }
}
