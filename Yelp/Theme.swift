//
//  Theme.swift
//  Yelp
//
//  Created by Deepthy on 9/23/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
let SelectedThemeKey = "SelectedTheme"

enum Theme: Int {
    case Default, Dark
    
    var mainColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 212/255, green: 32/255, blue: 43/255, alpha: 1.0) // red
            
        case .Dark:
            return UIColor()
            
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .Default:
            return UIColor.white
            
        case .Dark:
            return UIColor()
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 156.0/255.0, green: 156.0/255.0, blue: 156.0/255.0, alpha: 1.0)
            
        case .Dark:
            return UIColor()
        }
    }
    
    var secondaryBackgroundColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
            
        case .Dark:
            return UIColor()
        }
    }
}

struct ThemeManager {
    
    static func currentTheme() -> Theme {
        var storedTheme = 0
        
        if (UserDefaults.standard.value(forKey: SelectedThemeKey) != nil)
        {
            storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey)! as AnyObject).integerValue
        }
        
        return Theme(rawValue: storedTheme)!
    }
}
