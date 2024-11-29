//
//  APIClient.swift
//  Recipe
//
//  Created by Edward Groberski on 11/26/24.
//

import Foundation
import Dependencies
import UIKit

struct APIClient: Sendable {
    var fetchData: @Sendable (URL) async -> Result<Data, Error>
    
    enum Error: LocalizedError {
        case failure
        
        var errorDescription: String? {
            switch self {
            case .failure:
                "Unable to get data from URL"
            }
        }
    }
}

extension APIClient: DependencyKey {
    static let liveValue = Self { url in
        @Dependency(\.urlSession) var urlSession
        
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return .failure(.failure)
            }
              
            return .success(data)
        } catch {
            return .failure(.failure)
        }
    }
    
    static let failureValue = Self { _ in
        return .failure(.failure)
    }
    
    static let validRecipesValue = Self { _ in
        return .success(Data(jsonFile: RecipeJSONFile.valid.rawValue))
    }
    
    static let malformedRecipesValue = Self { _ in
        return .success(Data(jsonFile: RecipeJSONFile.malformed.rawValue))
    }
    
    static let emptyRecipesValue = Self { _ in
        return .success(Data(jsonFile: RecipeJSONFile.empty.rawValue))
    }
    
    static let validImageDataValue = Self { _ in
        return .success(foodImage.pngData()!)
    }
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
