//
//  YelpFilters.swift
//  Yelp
//
//  Created by Deepthy on 9/25/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

class YelpFilters {
    
    var searchString: String
    var categories: Set<String>
    var attributes: Set<String>
    var sort: Int
    var distance: Int
    var location: [String: String]
    
    init() {
        self.searchString = ""
        self.categories = Set<String>()
        self.attributes = Set<String>()
        self.sort = 0
        self.distance = 0
        self.location = ["latitude": "37.785771", "longitude": "-122.406165"]
    }
    
    init(_ filters: YelpFilters) {
        self.searchString = filters.searchString
        self.categories = filters.categories
        self.attributes = filters.attributes
        self.sort = filters.sort
        self.distance = filters.distance
        self.location = filters.location
    }
    
    func toggleCategory(_ name: String) {
        if categories.contains(name) {
            categories.remove(name)
        } else {
            categories.insert(name)
        }
    }
    
    func toggleAttribute(_ isOn: Bool, code: String) {
        print("Deals now \(isOn)")
        if isOn {
            attributes.insert(code)
        } else {
            attributes.remove(code)
        }
    }
    
   /* func toggleCategory(row: Int, isOn: Bool) {
        let code = Constants.yelpCategories[row]["code"]!
        if isOn {
            categories.insert(code)
        } else {
            categories.remove(code)
        }
        print("\(isOn ? "Added" : "Removed") \(code)")
    }
    
    func setParams(params: inout [String: String]) {
        if attributes.count > 0 {
            params["attributes"] = attributes.joined(separator: ",")
        }
        
        if categories.count > 0 {
            params["categories"] = categories.joined(separator: ",")
        }
        
        if !searchString.isEmpty {
            params["term"] = searchString
        }
        
        if sort > 0 {
            params["sort_by"] = Constants.sortModes[sort]["code"]
        }
        
        if distance > 0 {
            params["radius"] = Constants.distances[distance]["code"]
        }
        
    }*/
    
    static func getCode(options: [[String: String]], index: Int) -> String {
        return options[index]["code"]!
    }
}
