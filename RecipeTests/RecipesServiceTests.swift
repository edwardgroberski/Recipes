//
//  RecipesServiceTests.swift
//  RecipeTests
//
//  Created by Edward Groberski on 11/25/24.
//

import Testing
import Dependencies
import Foundation
@testable import Recipe

struct RecipesServiceTests {
    @Test func parsesRecipes() async throws {
        let service = withDependencies {
            $0.apiClient = .validRecipesValue
        } operation: {
            RecipesService.liveValue
        }
        let result = await service.fetchRecipes()
        #expect(try !result.get().isEmpty)
    }
    
    @Test func failsToParseRecipes() async throws {
        let service = withDependencies {
            $0.apiClient = .malformedRecipesValue
        } operation: {
            RecipesService.liveValue
        }
        await #expect(throws: (any Error).self) {
            try await service.fetchRecipes().get()
        }
    }
    
    @Test func emptyRecipes() async throws {
        let service = withDependencies {
            $0.apiClient = .emptyRecipesValue
        } operation: {
            RecipesService.liveValue
        }
        let result = await service.fetchRecipes()
        #expect(try result.get().isEmpty)
    }
}
