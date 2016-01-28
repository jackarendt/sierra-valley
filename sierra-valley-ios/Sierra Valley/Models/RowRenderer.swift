//
//  RowRenderer.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/26/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

func renderResourceRow(row : ResourceRow, rowBuffer: RowBufferItem, cameraPosition : CGPoint, color : UIColor , screenSize : CGSize) -> [SKNode] {
    // TODO: actually do this
    let positionX = cameraPosition.x + screenSize.width/2 + 30
    let positionY = cameraPosition.y - screenSize.height/2 + 80
    let rect = rowBuffer.rectangle!
    rect.position = CGPoint(x: positionX, y: positionY)
    rect.color = color
    rect.size = CGSize(width: 30, height: 200)
    
    let triangle = rowBuffer.triangle!
    triangle.position = CGPoint(x: positionX, y: positionY + rect.size.height/2 + 1.825)
    triangle.color = color
    triangle.size = CGSize(width: 30, height: 3.65)
    return [rect, triangle] // still BSed. needs to actually be fixed
}