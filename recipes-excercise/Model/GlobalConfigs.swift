//
//  GlobalConfigs.swift
//  recipes-excercise
//
//  Created by Kirill Emelyanenko on 8.11.23.
//

import Foundation

class GlobalConfigs {
    private static let backendHostname: String = "https://themealdb.com"
    private static let apiEndpoint: String = "/api/json/v1"
    private static let apiKey: String = "/1"
    
    static var backendString: String {
        get { backendHostname + apiEndpoint + apiKey }
    }
    
    static func lookupUrl(_ id: String) -> URL {
        URL(string: backendString + "/lookup.php?i=" + id)!
    }
    
    static var dessertsUrl: URL {
        get { URL(string: backendString + "/filter.php?c=Dessert")! }
    }
}
