//
//  RecipesListViewModelTests.swift
//  RecipeTests
//
//  Created by Edward Groberski on 11/27/24.
//

import Testing
import Dependencies
import Foundation
@testable import Recipe

struct RecipesListViewModelTests {
    struct State {
        @MainActor
        @Test func refreshRecipeSetsEmptyState() async throws {
            await withDependencies {
                $0.recipesService = .emptyValue
            } operation: {
                let viewModel = RecipesListViewModel()
                await viewModel.refreshRecipes()
                #expect(viewModel.state == .empty)
            }
        }
        
        @MainActor
        @Test func refreshRecipeSetsLoadedState() async throws {
            await withDependencies {
                $0.recipesService = .testValue
            } operation: {
                let viewModel = RecipesListViewModel()
                await viewModel.refreshRecipes()
                #expect(viewModel.state == .loaded(previewRecipes.map { RecipeItemViewModel(recipe: $0)}))
            }
        }
        
        @MainActor
        @Test func refreshRecipeSetsFailureState() async throws {
            await withDependencies {
                $0.recipesService = .errorValue
            } operation: {
                let viewModel = RecipesListViewModel()
                await viewModel.refreshRecipes()
                #expect(viewModel.state == .failure)
            }
        }
    }
}
