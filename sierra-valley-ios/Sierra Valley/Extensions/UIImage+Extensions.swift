//
//  UIImage+Extensions.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// Enumeration containing all images in the Asset Catalog
enum SVImage : String {
    case Background = "background"
    case Mountains = "mountains"
}

extension UIImage {
    /// Initialize image using the SVImage enum
    convenience init!(asset: SVImage) {
        self.init(named: asset.rawValue)
    }
}