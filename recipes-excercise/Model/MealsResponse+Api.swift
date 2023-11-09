//
//  MealsResponse+Api.swift
//  recipes-excercise
//
//  Created by Kirill Emelyanenko on 8.11.23.
//

import Foundation

/// Yes, absolutely simplified, no need to handle async groups or complex model handling, then no need to implement anything extra
/// Expecting only unusual errors, so no direct error handling is beneficial here

extension Meal {
    var details: [MealDetails] {
        get async throws {
            let (data, _) = try await URLSession.shared.data(from: GlobalConfigs.lookupUrl(self.id))
            let detailsResponse = try JSONDecoder().decode(MealDetailsResponse.self, from: data)
            return detailsResponse.meals
        }
    }
}

extension MealsResponse {
    static var all: [Meal] {
        get async throws {
            let (data, _) = try await URLSession.shared.data(from: GlobalConfigs.dessertsUrl)
            let mealsResponse = try JSONDecoder().decode(MealsResponse.self, from: data)
            return mealsResponse.meals
        }
    }
}
