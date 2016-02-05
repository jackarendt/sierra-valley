//
//  Arrow.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/22/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

enum ArrowDirection : Int {
    case Up = 0
    case Down = 180
    case Left = 90
    case Right = 270
}

class Arrow: UIView {
    
    let direction : ArrowDirection
    
    var fillColor = SVColor.lightColor() {
        didSet {
            base.strokeColor = fillColor.CGColor
            topLine.strokeColor = fillColor.CGColor
            bottomLine.strokeColor = fillColor.CGColor
        }
    }
    
    private let base = CAShapeLayer()
    private let topLine = CAShapeLayer()
    private let bottomLine = CAShapeLayer()

    init(frame: CGRect, direction : ArrowDirection) {
        self.direction = direction
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.direction = .Left
        super.init(coder: aDecoder)
        commonInit() // defaults to left
    }

    private func commonInit() {
        drawStraightLine(direction)
        drawArrow(direction)
    }
    
    private func drawStraightLine(direction : ArrowDirection)  {
        let path = UIBezierPath()
        if direction == .Up || direction == .Down {
            path.moveToPoint(CGPoint(x: bounds.width/2, y: 1))
            path.addLineToPoint(CGPoint(x: bounds.width/2, y: bounds.height - 2))
            path.closePath()
        } else {
            path.moveToPoint(CGPoint(x: 2, y: bounds.height/2))
            path.addLineToPoint(CGPoint(x: bounds.width - 2, y: bounds.height/2))
            path.closePath()
        }
        
        base.path = path.CGPath
        base.strokeColor = fillColor.CGColor
        base.lineWidth = 2.0
        layer.addSublayer(base)
    }
    
    private func drawArrow(direction : ArrowDirection) {
        switch direction {
        case .Up:
            drawArrowLine(CGPoint(x: bounds.width/2, y: 0), end: CGPoint(x: 0, y: bounds.width/2), arrowLayer: topLine)
            drawArrowLine(CGPoint(x: bounds.width/2, y: 0), end: CGPoint(x: bounds.width, y: bounds.width/2), arrowLayer: bottomLine)
        case .Down:
            drawArrowLine(CGPoint(x: bounds.width/2, y: bounds.height), end: CGPoint(x: 0, y: bounds.height - bounds.width/2), arrowLayer: topLine)
            drawArrowLine(CGPoint(x: bounds.width/2, y: bounds.height), end: CGPoint(x: bounds.width, y: bounds.height - bounds.width/2), arrowLayer: bottomLine)
        case .Left:
            drawArrowLine(CGPoint(x: 0, y: bounds.height/2), end: CGPoint(x: bounds.height/2, y: 0), arrowLayer: topLine)
            drawArrowLine(CGPoint(x: 0, y: bounds.height/2), end: CGPoint(x: bounds.height/2, y: bounds.height), arrowLayer: bottomLine)
        case .Right:
            drawArrowLine(CGPoint(x: bounds.width, y: bounds.height/2), end: CGPoint(x: bounds.width - bounds.height/2, y: 0), arrowLayer: topLine)
            drawArrowLine(CGPoint(x: bounds.width, y: bounds.height/2), end: CGPoint(x: bounds.width - bounds.height/2, y: bounds.height), arrowLayer: bottomLine)
        }
        
    }
    
    private func drawArrowLine(origin: CGPoint, end : CGPoint, arrowLayer : CAShapeLayer) {
        let path = UIBezierPath()
        path.moveToPoint(origin)
        path.addLineToPoint(end)
        path.closePath()
        
        arrowLayer.path = path.CGPath
        arrowLayer.strokeColor = fillColor.CGColor
        arrowLayer.lineWidth = 2.0
        layer.addSublayer(arrowLayer)
    }

}
