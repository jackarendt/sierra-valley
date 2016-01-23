//
//  HelpCarScene.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/22/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

class HelpCarScene: SVBaseScene {
    
    let car = CarNode(car: .SierraTurboLarge)
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        view.allowsTransparency = true
        backgroundColor = SKColor.clearColor()
        
        // add car to scene
        car.position = CGPoint(x: view.bounds.width/2, y: car.size.height/2 + 10)
        self.addChild(car)
    }
    
    override func tapGestureRecognized(tap: UITapGestureRecognizer) {
        print("Jump Car")
    }
    
    override func swipeLeftGestureRecognized(swipeLeft: UISwipeGestureRecognizer) {
        print("swipe left")
    }
    
    override func swipeRightGestureRecognized(swipeRight: UISwipeGestureRecognizer) {
        print("swipe right")
    }
}
