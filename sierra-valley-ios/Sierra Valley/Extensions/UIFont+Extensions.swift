//
//  UIFont+Extensions.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

extension UIFont {
    class func svFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "AvenirNext-UltraLight", size: size)
    }
    
    class func svHeavyFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "Avenir-Light", size: size)
    }
}
