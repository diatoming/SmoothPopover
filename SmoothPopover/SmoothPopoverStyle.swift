//
//  SmoothPopoverStyle.swift
//  SmoothPopover
//
//  Created by Дмитрий Николаев on 07.05.15.
//  Copyright (c) 2015 Dmitry Nikolaev. All rights reserved.
//

import AppKit

public struct SmoothPopoverStyle {
    var arrowBase = CGFloat(50)
    var arrowLength = CGFloat(10)
    var cornerRadius = CGFloat(5)
    var shadowBlurRadius = CGFloat(15)
    var shadowColor = NSColor(calibratedRed: 0, green: 0, blue: 0, alpha: 0.085)
    var backgroundColor = NSColor.whiteColor()
    var strokeColor = NSColor(calibratedRed: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    var strokeWidth = CGFloat(0.5)
}
