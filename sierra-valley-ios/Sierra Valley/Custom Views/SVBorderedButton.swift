//
//  SVBorderedButton.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// UIButton subclass with a border around the edges
public class SVBorderedButton: UIButton {
    
   public var borderColor : UIColor = UIColor.whiteColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
            setTitleColor(borderColor, forState: .Normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        titleLabel?.font = UIFont.svFont(17)
        layer.borderColor = borderColor.CGColor
        layer.borderWidth = 1
        
        addTarget(self, action: "touchUp", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragExit, .TouchDragOutside])
        addTarget(self, action: "touchDown", forControlEvents: [.TouchDown, .TouchDragEnter, .TouchDragInside, .TouchDownRepeat])
    }
    
    public func setFontSize(size: CGFloat) {
        titleLabel?.font = UIFont.svFont(size)
    }
    
    // MARK: - Selectors
    
    func touchUp() {
        backgroundColor = UIColor.clearColor()
        setTitleColor(borderColor, forState: .Normal)
    }
    
    func touchDown() {
        backgroundColor = borderColor
        setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
}
