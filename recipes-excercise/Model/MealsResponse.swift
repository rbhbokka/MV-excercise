//
//  MealsResponse.swift
//  recipes-excercise
//
//  Created by Kirill Emelyanenko on 6.11.23.
//

import Foundation

struct MealsResponse: Decodable {
    let meals: [Meal]
}

struct Meal: Decodable, Identifiable, Equatable {
    var id: String {
        get {
            idMeal
        }
    }
    
    let strMeal: String
    let strMealThumb: URL?
    let idMeal: String
    
    // keeping size lesser for thumbnails, strMealThumb is 700x700 most of the time, which is much more than needed
    // backend have thumbnails on "preview"
    var thumbnail: URL? {
        get {
            strMealThumb?.appending(path: "preview")
        }
    }
}
