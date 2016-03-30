//
//  SVSegmentedControl.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/29/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

class SVSegmentedControl: UISegmentedControl {
    override init(items: [AnyObject]?) {
        super.init(items: items)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        tintColor = SVColor.lightColor()
        layer.cornerRadius = 0
        layer.borderColor = SVColor.lightColor().CGColor
        layer.borderWidth = 1
        layer.masksToBounds = true
    }
}
