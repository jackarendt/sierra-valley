//
//  RowRenderer.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/26/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

func renderResourceRow(row : ResourceRow, rowBuffer: RowBufferItem, cameraPosition : CGPoint, color : UIColor , direction : CarDirection, gameSettings : GameSettings) -> [SKNode] {
    // TODO: actually do this
    var offset = gameSettings.actualWidth/2
    if direction == .Left {
        offset *= -1
    }
    let positionX = cameraPosition.x + offset
    let positionY = cameraPosition.y - UIScreen.mainScreen().bounds.height/2 + gameSettings.maxMountainHeight - 100 - row.depressedHeight
    
    
    var usedResources = [SKNode]()
    
    let rect = rowBuffer.rectangle!
    rect.position = CGPoint(x: positionX, y: positionY)
    rect.color = color
    rect.size = CGSize(width: 30, height: 200)
    usedResources.append(rect)
    
    if row.row.contains(1) {
        let triangle = rowBuffer.triangle!
        triangle.position = CGPoint(x: positionX, y: positionY + rect.size.height/2 + gameSettings.triangleHeight/2)
        triangle.color = color
        triangle.size = CGSize(width: 30, height: gameSettings.triangleHeight)
        usedResources.append(triangle)
    }

    if row.row.contains(2) {
        let spike = rowBuffer.spike!
        spike.position = CGPoint(x: positionX, y: positionY + rect.size.height/2 + spike.size.height/2)
        spike.color = color
        usedResources.append(spike)
    }
    

    return usedResources
}