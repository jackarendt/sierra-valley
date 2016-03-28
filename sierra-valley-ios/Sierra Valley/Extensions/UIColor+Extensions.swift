//
//  UIColor+Extensions.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Initializes a UIColor with Int instead of Float values
    convenience init(r : Int, g : Int, b : Int, a : Int = 255) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
}

/// The SVColor is a color class that contains all of the colors used in the game
class SVColor {
    
    // MARK: - Background Colors
    
    /// The Dark Blue background color - #0f3057
    class func darkBlueBackgroundColor() -> UIColor {
        return UIColor(r: 15, g: 48, b: 87)
    }
    
    /// The Light Blue background color - #84ccd1
    class func lightBlueBackgroundColor() -> UIColor {
        return UIColor(r: 132, g: 204, b: 209)
    }
    
    /// The light color that is used throughout - #ffffff
    class func lightColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func darkColor() -> UIColor {
        return UIColor(r: 28, g: 28, b: 28)
    }
    
    
    class func avalancheColor() -> UIColor {
        return UIColor(r: 236, g: 240, b: 241)
    }
    
    class func levelPrimaryColor() -> UIColor {
        return UIColor(r: 22, g: 160, b: 133)
    }
    
    class func levelSecondaryColor() -> UIColor {
       return UIColor(r: 34, g: 49, b: 63)
    }
    
    class func backgroundPrimaryColor() -> UIColor {
        return UIColor(r: 74, g: 84, b: 94)
    }
    
    class func backgroundSecondaryColor() -> UIColor {
        return UIColor(r: 114, g: 127, b: 128)
    }
}