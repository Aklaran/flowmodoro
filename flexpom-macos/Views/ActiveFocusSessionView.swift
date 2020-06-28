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
    
    private let picasso = PathDrawer()
    
    @IBOutlet var view: NSView!
    @IBOutlet weak var focusTimeLabel: NSTextField!
    @IBOutlet weak var breakTimeLabel: NSTextField!
    @IBOutlet weak var pomLabel: NSTextField!
    @IBOutlet weak var cloverLabel: NSTextField!
    @IBOutlet weak var focusButton: NSButton!

    var polygon: Polygon!
    
    let startAngleDeg: CGFloat = 90
    
    var arcCenter: CGPoint {
        CGPoint(x: self.view.getCenterPoint().x , y: self.view.getCenterPoint().y + 20)
    }
    
    var focusPercentage: CGFloat = 1

    let focusArcRadius: CGFloat = 60
    let focusArcLineWidth: CGFloat = 5
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
        
        self.polygon = Polygon(sides: 6,
                               center: CGPoint(x: self.view.getCenterPoint().x, y: self.view.getCenterPoint().y + 20),
                               radius: self.focusArcRadius,
                               isClockwise: false)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        picasso.drawPolygonSegment(polygon: self.polygon,
                                   lineWidth: self.focusArcLineWidth,
                                   color: .orange,
                                   percentComplete: self.focusPercentage)
        //self.drawFocusArc()
        // self.drawBreakArc()
    }
    
    private func drawFocusArc() {
        picasso.drawArc(center: CGPoint(x: self.view.getCenterPoint().x, y: self.view.getCenterPoint().y + 20),
                     radius: self.focusArcRadius,
                     lineWidth: self.focusArcLineWidth,
                     startAngle: self.startAngleDeg,
                     length: self.focusArcDeg,
                     color: .orange)
    }
    
    private func drawBreakArc() {
        picasso.drawArc(center: self.view.getCenterPoint(),
                     radius: self.breakArcRadius,
                     lineWidth: self.breakArcLineWidth,
                     startAngle: self.startAngleDeg,
                     length: self.breakArcDeg,
                     color: .blue)
    }
}
