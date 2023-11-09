//
//  ContentView.swift
//  recipes-excercise
//
//  Created by Kirill Emelyanenko on 6.11.23.
//

import SwiftUI

struct MealsListView: View {
    
    /// No need to over-engineer and bring VM while fighting the system
    /// just plain natural swiftUI approach, no need for Environment or State object and extra complexity for no benefit
    @State private var meals: [Meal] = []
    @State private var mealDetails: Meal? = nil
    
    @State private var errorMessage: LocalizedError? = nil
    @State private var searchQuery = "" /// Easier to test with search on board
    
    private var filteredMeals: [Meal] {
        get {
            meals.filter {
                guard !searchQuery.isEmpty else { return true }
                return $0.strMeal.lowercased().contains(searchQuery.lowercased())
            }
            .sorted(by: { $0.strMeal < $1.strMeal} )
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVStack() {
                    if filteredMeals.isEmpty {
                        StatusView()
                    } else {
                        ForEach(filteredMeals) { meal in
                            MealItemView(meal: meal)
                                .onTapGesture {
                                    mealDetails = meal
                                }
                        }
                    }
                }
                .contentTransition(.interpolate)
                .searchable(text: $searchQuery)
                .padding(.horizontal)
            }
            .animation(.bouncy, value: filteredMeals)
            .sheet(item: $mealDetails) { mealDetails in
                MealDetailsView(meal: mealDetails)
                    .presentationDetents([.medium,.large])
                    .presentationBackground(.regularMaterial)
                    .presentationCornerRadius(30.0)
            }
            .task {
                do {
                    meals = try await MealsResponse.all
                } catch {
                    errorMessage = error as? LocalizedError
                }
            }
        }
    }
    
    @ViewBuilder
    func StatusView() -> some View {
        if searchQuery.isEmpty {
            if let errorMessage {
                VStack {
                    Text(errorMessage.localizedDescription)
                    if let recoverySuggestion = errorMessage.recoverySuggestion {
                        Text(recoverySuggestion)
                    }
                }
            } else {
                VStack {
                    Text("Loading meals")
                        .font(.subheadline)
                    Divider()
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
        } else {
            Text("Nothing is found")
                .font(.subheadline)
        }
    }
}

#Preview {
    MealsListView()
}
