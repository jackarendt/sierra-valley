//
//  HelpCarScene.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/22/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

class HelpCarScene: SKScene {
    
    let car = SKSpriteNode(imageNamed: SVCar.SierraTurboLarge.rawValue)
    
    override func didMoveToView(view: SKView) {
        view.allowsTransparency = true
        backgroundColor = SKColor.clearColor()
        
        // add car to scene
        car.position = CGPoint(x: view.bounds.width/2, y: car.size.height/2 + 10)
        self.addChild(car)
    }    
}
