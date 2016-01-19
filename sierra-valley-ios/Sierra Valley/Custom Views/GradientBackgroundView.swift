//
//  GradientBackgroundView.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit
import SpriteKit

/// GradientBackgroundView will draw a gradient on a 60 degree angle with the dark blue being on the top left
/// and light blue being on the bottom right.
class GradientBackgroundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawGradient()
    }

    /// Draws a gradient on the view
    private func drawGradient() {
        var colorSpace : CGColorSpaceRef?
        if #available(iOS 9, *) { // Create color space
            colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB)
        } else {
            colorSpace = CGColorSpaceCreateDeviceRGB()
        }
        
        // add in background colors
        let colors = [SVColor.darkBlueBackgroundColor().CGColor, SVColor.lightBlueBackgroundColor().CGColor]
        let gradient = CGGradientCreateWithColors(colorSpace, colors, [0.0, 1.0])
        // draw gradient
        CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), gradient, CGPointZero, CGPoint(x: bounds.width, y: bounds.height), .DrawsAfterEndLocation)
    }
}
