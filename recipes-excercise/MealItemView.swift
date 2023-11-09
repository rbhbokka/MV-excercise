//
//  MealItemView.swift
//  recipes-excercise
//
//  Created by Kirill Emelyanenko on 8.11.23.
//

import SwiftUI

struct MealItemView: View {
    let meal: Meal
    
    var body: some View {
        HStack {
            AsyncImage(url: meal.thumbnail, transaction: .init(animation: .spring)) { phase in
                switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
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
                            .padding()
                }
            }
            .frame(width: 60.0, height: 60.0, alignment: .center)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10), style: .continuous))
            .shadow(radius: 5.0)
            Text(meal.strMeal)
                .font(.headline)
                .padding(.horizontal)
                .lineLimit(nil)
            Spacer()
        }
        
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10), style: .continuous))
    }
}

#Preview {
    MealItemView(meal: Meal(strMeal: "Apam balik", strMealThumb: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg"), idMeal: "53049"))
}
