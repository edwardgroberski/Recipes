//
//  RecipeItemViewModelTests.swift
//  RecipeTests
//
//  Created by Edward Groberski on 11/27/24.
//

import Testing
import Dependencies
import Foundation
@testable import Recipe

struct RecipeItemViewModelTests {
    private var recipeItemViewModel: RecipeItemViewModel!
    
    init () async throws {
        recipeItemViewModel = RecipeItemViewModel(recipe: recipe1)
    }
    
    @Test func nameEqualsRecipeName() async throws {
        #expect(recipeItemViewModel.name == recipe1.name)
    }
    
    @Test func cuisineEqualsRecipeCuisine() async throws {
        #expect(recipeItemViewModel.cuisine == recipe1.cuisine)
    }
    
    @Test func photoURLEqualsRecipePhotoURL() async throws {
        #expect(recipeItemViewModel.photoURL == URL(string: recipe1.photoUrlSmall!))
    }

}
