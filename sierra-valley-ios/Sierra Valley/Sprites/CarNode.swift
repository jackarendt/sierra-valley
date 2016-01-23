//
//  CarNode.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/23/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// The CarNode contains all of the business logic associated with driving the car
class CarNode: SKSpriteNode {
    
    /// The current car that is being presented
    var car : SVCar?
    
    init(car : SVCar) {
        self.car = car
        let texture = SKTextureAtlas(named: carsTextureAtlas).textureNamed(car.rawValue)
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
