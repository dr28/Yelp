//
//  FilterTableStructure.swift
//  Yelp
//
//  Created by Deepthy on 9/21/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class FilterTableStructure {
    
    
    var placeHolder: String = ""
    var enteredText = ""
    // var email: String = ""
    var hasImage : Bool! = false
    // var hasTextField: Bool!
    var tagNo: Int = 0
    
    
    
    // Returns a User initialized with the given text and default completed value.
    init(enteredText: String, placeHolder: String, hasImage : Bool) {
        self.enteredText = enteredText
        self.placeHolder = placeHolder
        self.hasImage = hasImage
        // self.hasTextField = hasTextField
        
        
    }
    
    
    
    
    
}
