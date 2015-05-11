//
//  SmoothPopover.swift
//  SmoothPopover
//
//  Created by Дмитрий Николаев on 07.05.15.
//  Copyright (c) 2015 Dmitry Nikolaev. All rights reserved.
//

import AppKit

@objc
public class SmoothPopover : NSObject, NSWindowDelegate {
    
    var window = SmoothPopoverWindow()
    var contentView: NSView
    var frameView: SmoothFrameView
    
    public init(contentView: NSView) {
        self.contentView = contentView
        self.frameView = SmoothFrameView()
        super.init()
        
        let popoverSize = self.frameView.frameSizeForContentSize(self.contentView.bounds.size)
        self.window.setFrame(NSRect(origin: NSPoint(), size: popoverSize), display: false) // if not set frame, it will be zero from the start, and will shifted somehow incorrectly
        self.frameView.addSubview(self.contentView)
        self.window.contentView = self.frameView
        self.window.delegate = self
    }
    
    public var shown: Bool {
        return self.window.visible
    }
    
    public func close() {
        self.window.close()
    }
    
    @objc
    public func showRelativeToView (positioningView: NSView, positioningRect: NSRect, edge: NSRectEdge) {
        
        let screenPositioningRect = positioningView.screenRectForRect(positioningRect)
        
        self.frameView.arrowEdge = arrowEdgeForPopoverEdge(edge)
        let popoverSize = self.frameView.frameSizeForContentSize(self.contentView.bounds.size)
        
        let shadowOffset = self.frameView.style.shadowBlurRadius
        var popoverFrame: NSRect
        
        switch edge {
            
        case NSMinYEdge:
            let positioningBottomMid = NSPoint(x: NSMidX(screenPositioningRect), y: NSMinY(screenPositioningRect))
            let popoverOrigin = NSPoint(x: positioningBottomMid.x - popoverSize.width/2, y: positioningBottomMid.y - popoverSize.height + shadowOffset)
            popoverFrame = NSRect(origin: popoverOrigin, size: popoverSize)
            
        case NSMaxYEdge:
            let positioningTopMid = NSPoint(x: NSMidX(screenPositioningRect), y: NSMaxY(screenPositioningRect))
            let popoverOrigin = NSPoint(x: positioningTopMid.x - popoverSize.width/2, y: positioningTopMid.y - shadowOffset)
            popoverFrame = NSRect(origin: popoverOrigin, size: popoverSize)

        case NSMinXEdge:
            let positioningLeftMid = NSPoint(x: NSMinX(screenPositioningRect), y: NSMidY(screenPositioningRect))
            let popoverOrigin = NSPoint(x: positioningLeftMid.x - popoverSize.width + shadowOffset, y: positioningLeftMid.y - popoverSize.height/2)
            popoverFrame = NSRect(origin: popoverOrigin, size: popoverSize)

        case NSMaxXEdge:
            let positioningRightMid = NSPoint(x: NSMaxX(screenPositioningRect), y: NSMidY(screenPositioningRect))
            let popoverOrigin = NSPoint(x: positioningRightMid.x - shadowOffset, y: positioningRightMid.y - popoverSize.height/2)
            popoverFrame = NSRect(origin: popoverOrigin, size: popoverSize)
            
        default:
            popoverFrame = NSZeroRect
        }
        
        self.contentView.setFrameOrigin(self.frameView.contentFrameForCurrentFrameSize().origin)
        self.window.setFrame(popoverFrame, display: true)
        self.window.makeKeyAndOrderFront(nil)
    }
    
    private func arrowEdgeForPopoverEdge (popoverEdge: NSRectEdge) -> NSRectEdge {
        switch popoverEdge {
        case NSMinXEdge:
            return NSMaxXEdge
        case NSMaxXEdge:
            return NSMinXEdge
        case NSMinYEdge:
            return NSMaxYEdge
        case NSMaxYEdge:
            return NSMinYEdge
        default:
            return popoverEdge
        }
    }
    
    public func windowDidResignKey(notification: NSNotification) {
        self.window.close()
    }
    
    public func windowDidResignMain(notification: NSNotification) {
        self.window.close()
    }
    
}

public class SmoothPopoverWindow: NSWindow {
    
    public init() {
        super.init(contentRect: NSZeroRect, styleMask: NSBorderlessWindowMask, backing: .Buffered, defer: false)
        
        self.movableByWindowBackground = false;
        self.alphaValue = 1
        self.opaque = false
        self.backgroundColor = NSColor.clearColor()
        self.hasShadow = false
        self.releasedWhenClosed = false
        
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var canBecomeMainWindow: Bool {
        get {return false}
    }
    
    override public var canBecomeKeyWindow: Bool {
        get {return true}
    }
    
}


extension NSView {
    func screenRectForRect (var rect: NSRect) -> NSRect {
        if (rect == NSZeroRect) {
            rect = self.bounds
        }
        
        let windowRect = convertRect(rect, toView: nil)
        let screenRect = window!.convertRectToScreen(windowRect)

        return screenRect
    }
}
