//
//  RecipesListViewModel.swift
//  Recipe
//
//  Created by Edward Groberski on 11/26/24.
//

import Foundation
import Dependencies

@Observable
final class RecipesListViewModel: Sendable {
    @MainActor
    private(set) var state: State = .loading
    
    @MainActor
    var isLoading: Bool { state == .loading }
    
    init() {}
    
    func refreshRecipes() async {
        await setLoadingState()
        
        @Dependency(\.recipesService) var recipeService
        let result = await recipeService.fetchRecipes()
        
        switch result {
        case .success(let recipes):
            if recipes.isEmpty {
                await setEmptyState()
                return
            } else {
                await setLoadedState(recipes)
            }
            
        case .failure(let error):
            print("Error fetching recipes: \(error)")
            await setFailureState()
        }
    }
}

extension RecipesListViewModel{
    
    @MainActor
    func setLoadingState() {
        state = .loading
    }
    
    @MainActor
    func setLoadedState(_ recipes: [Recipe]) {
        state = .loaded(recipes.map { RecipeItemViewModel(recipe: $0) })
    }
    
    @MainActor
    func setEmptyState() {
        state = .empty
    }
    
    @MainActor
    func setFailureState() {
        state = .failure
    }
}

extension RecipesListViewModel{
    enum State: Equatable {
        case loading
        case loaded([RecipeItemViewModel])
        case empty
        case failure
        
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading),
                (.empty, .empty),
                (.failure, .failure):
                return true
            case let (.loaded(lhsRecipes), .loaded(rhsRecipes)):
                return lhsRecipes == rhsRecipes
            default:
                return false
            }
        }
    }
}
