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
    let focusArcRadius: CGFloat = 50
    let startAngleDeg: CGFloat = 90
    
    @IBOutlet var view: NSView!
    @IBOutlet weak var focusTimeLabel: NSTextField!
    @IBOutlet weak var breakTimeLabel: NSTextField!
    
    var focusArcDeg: CGFloat = 360
    var lineWidth: CGFloat = 5
    
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
        
        self.drawFocusCircle()
    }
    
    private func drawFocusCircle() {
        // Create actual ring path
        let path = NSBezierPath()
        path.lineWidth = self.lineWidth
        path.move(to: self.view.getCenterPoint())
        
        path.appendArc(withCenter: self.view.getCenterPoint(),
                       radius: self.focusArcRadius,
                       startAngle: self.startAngleDeg,
                       endAngle: self.startAngleDeg + self.focusArcDeg)
        path.close()
        
        // Create inner clipping path to hide the arc lines
        let clippingPath = NSBezierPath()
        clippingPath.move(to: self.view.getCenterPoint())
        clippingPath.appendArc(withCenter: self.view.getCenterPoint(),
                               radius: self.focusArcRadius - self.lineWidth,
                               startAngle: self.startAngleDeg,
                               endAngle: self.startAngleDeg + self.focusArcDeg)
        clippingPath.close()
        
        // Clip the outer path by the inner path
        path.append(clippingPath)
        path.addClip()
        path.windingRule = .evenOdd
        
        // Fill!
        NSColor.red.setFill()
        path.fill()
    }
}
