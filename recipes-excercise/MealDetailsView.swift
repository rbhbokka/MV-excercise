//
//  MealDetailsView.swift
//  recipes-excercise
//
//  Created by Kirill Emelyanenko on 6.11.23.
//

import SwiftUI

struct MealDetailsView: View {
    let meal: Meal
    @State private var mealDetails: MealDetails? = nil
    @State private var errorMessage: LocalizedError? = nil
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                if let mealDetails {
                    LazyVStack {
                        AsyncImage(url: mealDetails.urlMealThumb, scale: 1.0, transaction: .init(animation: .spring)) { imagePhase in
                            switch imagePhase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .clipped()
                                        .transition(.move(edge: .top))
                                case .failure:
                                    /// some of meals don't have a thumbnail
                                    VStack {
                                        Image(systemName: "birthday.cake.fill")
                                        Text("The cake is a lie")
                                            .font(.caption2)
                                            .multilineTextAlignment(.center)
                                    }
                               default:
                                    ProgressView()
                                        .progressViewStyle(.circular)
                            }
                        }
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .continuous))
                        .shadow(radius: 5.0)
                        .padding([.horizontal, .top])
                        
                        Text(mealDetails.strMeal)
                            .font(.title)
                        
                        if !mealDetails.ingredients.isEmpty {
                            GroupBox("Ingredients") {
                                LazyVGrid(columns: [GridItem( alignment: .leading), GridItem( alignment: .leading)], alignment: .leading, spacing: 10.0) {
                                    ForEach(mealDetails.ingredients, id: \.hashValue) { ingredient in
                                        HStack {
                                            Text(ingredient.ingredient.capitalized)
                                                .font(.callout)
                                            Text(ingredient.measure)
                                                .font(.callout)
                                                .bold()
                                        }
                                    }
                                }
                                .padding(.top)
                            }
                        }
                        
                        if let strInstructions = mealDetails.strInstructions {
                            GroupBox("Instructions") {
                                Text(strInstructions)
                                    .font(.callout)
                                    .lineSpacing(5.0)
                                    .padding(.top)
                            }
                        }
                    }
                } else {
                    VStack {
                        AsyncImage(url: meal.thumbnail)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10), style: .continuous))
                        Text(meal.strMeal)
                            .font(.headline)
                        Divider()
                        if let errorMessage {
                            VStack {
                                Text(errorMessage.localizedDescription)
                                if let recoverySuggestion = errorMessage.recoverySuggestion {
                                    Text(recoverySuggestion)
                                }
                            }
                        } else {
                            Text("Loading recipe")
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding()
        .task {
            /// didn't find any documentation for this API, so assume that response should return only one meal by its ID
            do {
                mealDetails = try await meal.details.first
            } catch {
                print(error.localizedDescription)
                errorMessage = error as? LocalizedError
            }
        }
    }
}

#Preview {
    MealDetailsView(meal: Meal(strMeal: "Apam balik", strMealThumb: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg"), idMeal: "53049"))
}
