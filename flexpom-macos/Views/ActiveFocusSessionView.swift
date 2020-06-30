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
    
    static let DEFAULT_START_ANGLE: CGFloat = 90
    
    @IBOutlet var view: NSView!
    @IBOutlet weak var focusTimeLabel: NSTextField!
    @IBOutlet weak var breakTimeLabel: NSTextField!
    @IBOutlet weak var pomLabel: NSTextField!
    @IBOutlet weak var cloverLabel: NSTextField!
    @IBOutlet weak var focusButton: NSButton!

    var focusPolygon: Polygon!
    var currentBreakPolygon: Polygon!
    
    var startAngleDeg: CGFloat = ActiveFocusSessionView.DEFAULT_START_ANGLE
    
    var arcCenter: CGPoint {
        CGPoint(x: self.view.getCenterPoint().x , y: self.view.getCenterPoint().y + 20)
    }
    
    var focusPercentage: CGFloat = 0
    var breakPercentage: CGFloat = 0

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
        
        self.generatePolygons(isBreak: false)
    }
    
    func generatePolygons(isBreak: Bool) {
        self.focusPolygon = Polygon(sides: 6,
                               center: CGPoint(x: self.view.getCenterPoint().x, y: self.view.getCenterPoint().y + 20),
                               radius: self.focusArcRadius,
                               startAngleDeg: self.startAngleDeg,
                               isClockwise: false)
        
        let breakPolyShouldBeClockwise = !isBreak
        self.currentBreakPolygon = Polygon(sides: 6,
                                           center: CGPoint(x: self.view.getCenterPoint().x, y: self.view.getCenterPoint().y + 20),
                                           radius: self.focusArcRadius,
                                           startAngleDeg: self.startAngleDeg,
                                           isClockwise: breakPolyShouldBeClockwise)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        drawBreakPolygonSegment()
        drawFocusPolygonSegment()
    }
    
    private func drawFocusPolygonSegment() {
        picasso.drawPolygonSegment(polygon: self.currentBreakPolygon,
                                   lineWidth: self.focusArcLineWidth,
                                   color: .blue,
                                   percentComplete: self.breakPercentage)
    }
    
    private func drawBreakPolygonSegment() {
        picasso.drawPolygonSegment(polygon: self.focusPolygon,
                                   lineWidth: self.focusArcLineWidth,
                                   color: .orange,
                                   percentComplete: self.focusPercentage)
    }
}
