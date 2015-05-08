//
//  AppDelegate.swift
//  SmoothPopoverSample
//
//  Created by Дмитрий Николаев on 06.05.15.
//  Copyright (c) 2015 Dmitry Nikolaev. All rights reserved.
//

import Cocoa
import SmoothPopover

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var popover: SmoothPopover!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        let view = SampleView(frame: NSRect(x: 0, y: 0, width: 200, height: 200))
        self.popover = SmoothPopover(contentView: view)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    @IBAction func showPopoverButtonClicked(sender: NSButton) {
        self.popover.showRelativeToView(sender, positioningRect: NSZeroRect, edge: NSMaxXEdge)
    }
}

class SampleView : NSView {
    
    override func drawRect(dirtyRect: NSRect) {
        let fillRect = NSInsetRect(self.bounds, 10, 10)
        NSColor.blueColor().setFill()
        NSRectFill(fillRect)
    }
    
}
