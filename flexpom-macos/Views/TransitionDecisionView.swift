//
//  TransitionDecisionView.swift
//  flexpom-macos
//
//  Created by Bo Tembunkiart on 6/24/20.
//  Copyright © 2020 stembunk. All rights reserved.
//

import Cocoa

class TransitionDecisionView: NSView {
    private let nibName = "TransitionDecisionView"
    
    @IBOutlet var view: NSView!
    @IBOutlet weak var keepFocusingButton: NSButton!
    @IBOutlet weak var breakButton: NSButton!
    
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
}
