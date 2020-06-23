//
//  ActiveFocusSessionView.swift
//  flexpom-macos
//
//  Created by Bo Tembunkiart on 6/23/20.
//  Copyright © 2020 stembunk. All rights reserved.
//

import Cocoa

class ActiveFocusSessionView: NSView {
    let nibName = "ActiveFocusSessionView"
    let startAngleDeg: CGFloat = 90
    
    @IBOutlet var view: NSView!
    @IBOutlet weak var focusTimeLabel: NSTextField!
    @IBOutlet weak var breakTimeLabel: NSTextField!
    @IBOutlet weak var pomLabel: NSTextField!
    @IBOutlet weak var cloverLabel: NSTextField!
    
    let focusArcRadius: CGFloat = 50
    let focusArcLineWidth: CGFloat = 10
    var focusArcDeg: CGFloat = 360
    
    let breakArcRadius: CGFloat = 60
    let breakArcLineWidth: CGFloat = 5
    var breakArcDeg: CGFloat = 0
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(self.nibName, owner: self, topLevelObjects: nil)
        self.view.fixInView(self)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        self.drawFocusArc()
        self.drawBreakArc()

    }
    
    private func drawFocusArc() {
        self.drawArc(center: self.view.getCenterPoint(),
                     radius: self.focusArcRadius,
                     lineWidth: self.focusArcLineWidth,
                     startAngle: self.startAngleDeg,
                     length: self.focusArcDeg,
                     color: .orange)
    }
    
    private func drawBreakArc() {
//        // Create actual ring path
//        let path = NSBezierPath()
//        path.lineWidth = self.breakArcLineWidth
//        path.move(to: self.view.getCenterPoint())
//
//        path.appendArc(withCenter: self.view.getCenterPoint(),
//                       radius: self.breakArcRadius,
//                       startAngle: self.startAngleDeg,
//                       endAngle: self.startAngleDeg + self.breakArcDeg)
//        path.close()
//
//        // Create inner clipping path to hide the arc lines
//        let clippingPath = NSBezierPath()
//        clippingPath.move(to: self.view.getCenterPoint())
//        clippingPath.appendArc(withCenter: self.view.getCenterPoint(),
//                               radius: self.breakArcRadius - self.breakArcLineWidth,
//                               startAngle: self.startAngleDeg,
//                               endAngle: self.startAngleDeg + self.breakArcDeg)
//        clippingPath.close()
//
//        // Clip the outer path by the inner path
//        path.append(clippingPath)
//        path.addClip()
//        path.windingRule = .evenOdd
//
//        // Fill!
//        NSColor.red.setFill()
//        path.fill()
        
        self.drawArc(center: self.view.getCenterPoint(),
                     radius: self.breakArcRadius,
                     lineWidth: self.breakArcLineWidth,
                     startAngle: self.startAngleDeg,
                     length: self.breakArcDeg,
                     color: .blue)
    }
    
    private func drawArc(center: CGPoint, radius: CGFloat, lineWidth: CGFloat, startAngle: CGFloat, length: CGFloat, color: NSColor) {
        // Create actual ring path
        let path = NSBezierPath()
        path.lineWidth = lineWidth
        path.move(to: center)
        
        path.appendArc(withCenter: center,
                       radius: radius,
                       startAngle: startAngle,
                       endAngle: startAngle + length)
        path.close()
        
        // Create inner clipping path to hide the arc lines
        let clippingPath = NSBezierPath()
        clippingPath.move(to: center)
        clippingPath.appendArc(withCenter: center,
                               radius: radius - lineWidth,
                               startAngle: startAngle,
                               endAngle: startAngle + length)
        clippingPath.close()
        
        // Clip the outer path by the inner path
        path.append(clippingPath)
        path.addClip()
        path.windingRule = .evenOdd
        
        // Fill!
        color.setFill()
        path.fill()
    }
}
