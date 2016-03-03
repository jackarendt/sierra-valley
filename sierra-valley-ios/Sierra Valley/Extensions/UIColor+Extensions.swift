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
    
    // MARK: - Mountain Colors
    
    /// The darkest color of the mountains - #721544
    class func darkMaroonColor() -> UIColor {
        return UIColor(r: 114, g: 32, b: 61)
    }
    
    /// The second darkest color of the mountains - #962543
    class func maroonColor() -> UIColor {
        return UIColor(r: 150, g: 37, b: 67)
    }
    
    /// The off-red color of the mountains #b43c45
    class func redColor() -> UIColor {
        return UIColor(r: 180, g: 60, b: 69)
    }
    
    /// The sunrise orange color of the mountains (second lightest) - #ce4847
    class func sunriseOrangeColor() -> UIColor {
        return UIColor(r: 206, g: 72, b: 71)
    }
    
    /// The orange color of the mountains (lightest) - #f67a47
    class func orangeColor() -> UIColor {
        return UIColor(r: 246, g: 122, b: 71)
    }
    
    /// The light color that is used throughout - #ffffff
    class func lightColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    
    class func avalancheColor() -> UIColor {
        return UIColor(r: 222, g: 222, b: 222)
    }
    
    class func levelPrimaryColor() -> UIColor {
//        return UIColor(r: 231, g: 96, b: 55)
        return sunriseOrangeColor()
    }
    
    class func levelSecondaryColor() -> UIColor {
//        return UIColor(r: 171, g: 63, b: 63)
        return darkMaroonColor()
    }
    
    class func backgroundMaroonColor() -> UIColor {
        return UIColor(r: 150, g: 40, b: 27)
    }
    
    class func backgroundPurpleColor() -> UIColor {
        return UIColor(r: 102, g: 59, b: 120)
    }
}