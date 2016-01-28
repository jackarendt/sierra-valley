//
//  RowRenderer.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/26/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

func renderResourceRow(row : ResourceRow, cameraPosition : CGPoint, color : UIColor , screenSize : CGSize) -> [SKNode] {
    // TODO: actually do this
    let positionX = cameraPosition.x + screenSize.width/2 + 30
    let positionY = cameraPosition.y - screenSize.height/2 + 80
    let rect = RectangleNode(position: CGPoint(x: positionX, y: positionY), color: color, resourceSize: CGSize(width: 30, height: 200))
    let spike = SpikeNode(position: CGPoint(x: positionX, y: positionY + rect.size.height/2 + 13), color: color, resourceSize: CGSizeZero)
    return [rect, spike]
}