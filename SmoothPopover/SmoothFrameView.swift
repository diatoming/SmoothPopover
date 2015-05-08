//
//  SmoothContentView.swift
//  SmoothPopover
//
//  Created by Дмитрий Николаев on 06.05.15.
//  Copyright (c) 2015 Dmitry Nikolaev. All rights reserved.
//

import AppKit

public class SmoothFrameView : NSView {
    
    public var style: SmoothPopoverStyle {
        didSet {
            self.needsDisplay = true
        }
    }
    
    public var arrowEdge: NSRectEdge = 0 {
        didSet {
            self.needsDisplay = true
        }
    }
    
    public override init(frame frameRect: NSRect) {
        self.style = SmoothPopoverStyle()
        super.init(frame: frameRect)
    }
    
    public init(style: SmoothPopoverStyle) {
        self.style = style
        super.init(frame: NSZeroRect)
    }

    public convenience init() {
        self.init(style: SmoothPopoverStyle())
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var alignmentRectInsets: NSEdgeInsets {
        return NSEdgeInsets(top: self.style.shadowBlurRadius, left: self.style.shadowBlurRadius, bottom: self.style.shadowBlurRadius, right: self.style.shadowBlurRadius)
    }
    
    public override func drawRect(dirtyRect: NSRect) {
        
        NSGraphicsContext.saveGraphicsState()
        
        let contentPath = self.contentPath()

        let shadow = NSShadow()
        shadow.shadowColor = self.style.shadowColor
        shadow.shadowBlurRadius = self.style.shadowBlurRadius
        shadow.set()
        
        self.style.backgroundColor.setFill()
        contentPath.fill()

        NSGraphicsContext.restoreGraphicsState()

        contentPath.lineWidth = self.style.strokeWidth
        self.style.strokeColor.setStroke()
        contentPath.stroke()

    }
    
    public func frameSizeForContentSize (contentSize: NSSize) -> NSSize {
        var viewSize = NSSize(width: contentSize.width + style.shadowBlurRadius*2, height: contentSize.height + style.shadowBlurRadius*2)
        if (arrowEdge == NSMinXEdge || arrowEdge == NSMaxXEdge) {
            viewSize.width += style.arrowLength
        } else {
            viewSize.height += style.arrowLength
        }
        return viewSize
    }
    
    public func contentFrameForCurrentFrameSize() -> NSRect {
        var contentFrame = NSInsetRect(self.bounds, self.style.shadowBlurRadius, self.style.shadowBlurRadius)
        
        switch self.arrowEdge {
        case NSMaxYEdge:
            contentFrame.size.height -= self.style.arrowLength
        case NSMaxXEdge:
            contentFrame.size.width -= self.style.arrowLength
        case NSMinYEdge:
            contentFrame.size.height -= self.style.arrowLength
            contentFrame.origin.y += self.style.arrowLength
        case NSMinXEdge:
            contentFrame.size.width -= self.style.arrowLength
            contentFrame.origin.x += self.style.arrowLength
        default:
            println("Invalid edge")
        }
        return contentFrame
    }
    
    private func contentPath() -> NSBezierPath {
        var contentRect = NSInsetRect(self.bounds, self.style.shadowBlurRadius, self.style.shadowBlurRadius)
        
        if (self.arrowEdge == NSMinXEdge || self.arrowEdge == NSMaxXEdge) {
            contentRect.size = NSSize(width: contentRect.height, height: contentRect.width)
        }
        
        let center = NSPoint(x: NSMidX(self.bounds), y: NSMidY(self.bounds))
        contentRect.origin.x = center.x - NSWidth(contentRect)/2
        contentRect.origin.y = center.y - NSHeight(contentRect)/2
        
        let pathBuilder = SmoothPathBuilder()
        pathBuilder.rect = contentRect
        pathBuilder.arrowLength = self.style.arrowLength
        pathBuilder.arrowBase = self.style.arrowBase
        let path = pathBuilder.build()
        
        switch self.arrowEdge {
        case NSMaxYEdge:
            path
        case NSMaxXEdge:
            path.rotateAroundCenterByDegrees(270)
        case NSMinYEdge:
            path.rotateAroundCenterByDegrees(180)
        case NSMinXEdge:
            path.rotateAroundCenterByDegrees(90)
        default:
            println("Invalid edge")
        }
        
        return path
    }

}


