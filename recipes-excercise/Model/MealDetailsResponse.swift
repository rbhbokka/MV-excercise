//
//  MealDetailsResponse.swift
//  recipes-excercise
//
//  Created by Kirill Emelyanenko on 6.11.23.
//

import Foundation
import OrderedCollections

struct MealDetailsResponse: Decodable {
    let meals: [MealDetails]
}

/// Actual response have a lot more fields but requirements want only  Meal name,  Instructions, Ingredients/measurements
/// Why to risc with other fields possible decoding errors?
struct MealDetails: Decodable {
    let idMeal: String
    let strMeal: String
    let strInstructions: String?
    let strMealThumb: String?
    let ingredients: OrderedSet<Ingredient>
    
    var urlMealThumb: URL? {
        get {
            guard let strMealThumb else { return nil }
            return URL(string: strMealThumb)
        }
    }
    
    // ingredients can be duplicated from time to time on backend side so we need to look for hash
    struct Ingredient: Hashable {
        var ingredient: String
        var measure: String
    }
    
    enum CodingKeys: CodingKey {
        case idMeal
        case strMeal
        case strDrinkAlternate
        case strCategory
        case strArea
        case strInstructions
        case strMealThumb
        case strTags
        case strYoutube
        case strSource
        case strImageSource
        case strCreativeCommonsConfirmed
        case dateModified
    }
    
    private struct DynamicCodingKeys: CodingKey {

            // Use for string-keyed dictionary
            var stringValue: String
            init?(stringValue: String) {
                self.stringValue = stringValue
            }

            // Use for integer-keyed dictionary
            var intValue: Int?
            init?(intValue: Int) {
                // We are not using this, thus just return nil
                return nil
            }
        }
    
    /// Most fun part  you are probably looking for
    /// - Parameter decoder: decoder for ingredients is dynamically keyed to avoid duplication and to make a real collection of ingredients instead of just pile of static vaiables
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.idMeal = try container.decode(String.self, forKey: .idMeal)
        self.strMeal = try container.decode(String.self, forKey: .strMeal)
        self.strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        self.strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var ingredientsCollection = OrderedSet<Ingredient>() // OrderedSet allows to be used by ForEach and still checking for uniqueness
        for i in 1...20 {
            if
                let ingredientName = try dynamicContainer.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strIngredient\(i)")!), !ingredientName.isEmpty,
                let ingredientMeasure = try dynamicContainer.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strMeasure\(i)")!), !ingredientMeasure.isEmpty {
                ingredientsCollection.append(Ingredient(ingredient: ingredientName, measure: ingredientMeasure))
            }
        }
        self.ingredients = ingredientsCollection
    }
}
