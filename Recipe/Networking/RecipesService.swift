//
//  RecipesService.swift
//  Recipe
//
//  Created by Edward Groberski on 11/25/24.
//

import Foundation
import Dependencies

struct RecipesService: Sendable {
    var fetchRecipes: @Sendable () async -> Result<[Recipe], Error>
    
    enum API: String, Codable {
        case valid = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        case malformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        case empty = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    }
}

extension RecipesService: DependencyKey {
    static var liveValue: RecipesService {
        @Dependency(\.apiClient) var apiClient
        
        return Self {
            await Result {
                let url = URL(string: API.valid.rawValue)!
                let result = await apiClient.fetchData(url)
                
                switch result {
                case .success(let data):
                    return try JSONDecoder().decode(RecipesResponse.self, from: data).recipes
                case .failure(let error):
                    throw error
                }
            }
        }
    }
    
    static var testValue: RecipesService {
        return Self {
            return .success(previewRecipes)
        }
    }
    
    static var emptyValue: RecipesService {
        return Self {
            return .success([])
        }
    }
    
    static var errorValue: RecipesService {
        return Self {
            .failure(APIClient.Error.failure)
        }
    }
    
    static var previewValue: RecipesService {
        return Self {
            return .success(previewRecipes)
        }
    }
}

extension DependencyValues {
    var recipesService: RecipesService {
        get { self[RecipesService.self] }
        set { self[RecipesService.self] = newValue }
    }
}

