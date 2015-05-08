//
//  SmoothBezierPathBuilder.swift
//  SmoothPopover
//
//  Created by Дмитрий Николаев on 06.05.15.
//  Copyright (c) 2015 Dmitry Nikolaev. All rights reserved.
//

import AppKit

class SmoothPathBuilder {
    
    var rect = NSRect(x: 0, y: 0, width: 200, height: 150)
    var cornerRadius = CGFloat(10)
    var arrowLength = CGFloat(10)
    var arrowBase = CGFloat(50)
    
    func build() -> NSBezierPath {
        
        let verticalLineHeight = self.rect.size.height - self.arrowLength - self.cornerRadius * 2
        let horizontalLineWidth = self.rect.size.width - self.cornerRadius * 2
        
        let x0 = self.rect.origin.x
        let x1 = x0 + self.cornerRadius
        let x2 = x1 + horizontalLineWidth
        let x3 = x2 + self.cornerRadius
        let xArrowMid = x1 + horizontalLineWidth/2
        let xArrowLeft = xArrowMid - self.arrowBase/2
        let xArrowRight = xArrowMid + self.arrowBase/2
        
        let y0 = self.rect.origin.y
        let y1 = y0 + self.cornerRadius
        let y2 = y1 + verticalLineHeight
        let y3 = y2 + self.cornerRadius
        let yArrowTop = y3 + self.arrowLength
        
        let result = NSBezierPath()
        result.moveToPoint(NSPoint(x: x0, y: y1))
        result.lineToPoint(NSPoint(x: x0, y: y2))
        result.curveToPoint(NSPoint(x: x1, y: y3), controlPoint1: NSPoint(x: x0, y: y2), controlPoint2: NSPoint(x: x0, y: y3))
        result.lineToPoint(NSPoint(x: xArrowLeft, y: y3))
        
        result.curveToPoint(NSPoint(x: xArrowMid, y: yArrowTop), controlPoint1: NSPoint(x: xArrowMid, y: y3), controlPoint2: NSPoint(x: xArrowMid, y: yArrowTop))
        result.curveToPoint(NSPoint(x: xArrowRight, y: y3), controlPoint1: NSPoint(x: xArrowMid, y: yArrowTop), controlPoint2: NSPoint(x: xArrowMid, y: y3))
        
        result.lineToPoint(NSPoint(x: x2, y: y3))
        result.curveToPoint(NSPoint(x: x3, y: y2), controlPoint1: NSPoint(x: x2, y: y3), controlPoint2: NSPoint(x: x3, y: y3))
        result.lineToPoint(NSPoint(x: x3, y: y1))
        result.curveToPoint(NSPoint(x: x2, y: y0), controlPoint1: NSPoint(x: x3, y: y1), controlPoint2: NSPoint(x: x3, y: y0))
        result.lineToPoint(NSPoint(x: x1, y: y0))
        result.curveToPoint(NSPoint(x: x0, y: y1), controlPoint1: NSPoint(x: x1, y: y0), controlPoint2: NSPoint(x: x0, y: y0))
        result.closePath()
        
        return result
    }
}

public extension NSBezierPath {
    func rotateAroundCenterByDegrees(angle: CGFloat) {
        let center = NSPoint(x: NSMidX(self.bounds), y: NSMidY(self.bounds))
        let affineTransform = NSAffineTransform()
        affineTransform.translateXBy(center.x, yBy: center.y)
        affineTransform.rotateByDegrees(angle)
        affineTransform.translateXBy(-center.x, yBy: -center.y)
        self.transformUsingAffineTransform(affineTransform)
    }
}
