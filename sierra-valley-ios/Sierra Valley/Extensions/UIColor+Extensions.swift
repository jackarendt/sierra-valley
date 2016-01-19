//
//  UIColor+Extensions.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit
import SpriteKit

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
    class func darkBlueBackgroundColor() -> SKColor {
        return SKColor(r: 15, g: 48, b: 87)
    }
    
    /// The Light Blue background color - #84ccd1
    class func lightBlueBackgroundColor() -> SKColor {
        return SKColor(r: 132, g: 204, b: 209)
    }
    
    // MARK: - Mountain Colors
    
    /// The darkest color of the mountains - #721544
    class func darkMaroonColor() -> SKColor {
        return SKColor(r: 114, g: 21, b: 68)
    }
    
    /// The second darkest color of the mountains - #962543
    class func maroonColor() -> SKColor {
        return SKColor(r: 150, g: 37, b: 67)
    }
    
    /// The off-red color of the mountains #b43c45
    class func redColor() -> SKColor {
        return SKColor(r: 180, g: 60, b: 69)
    }
    
    /// The sunrise orange color of the mountains (second lightest) - #ce4847
    class func sunriseOrangeColor() -> SKColor {
        return SKColor(r: 206, g: 72, b: 71)
    }
    
    /// The orange color of the mountains (lightest) - #f67a47
    class func orangeColor() -> SKColor {
        return SKColor(r: 246, g: 122, b: 71)
    }
}