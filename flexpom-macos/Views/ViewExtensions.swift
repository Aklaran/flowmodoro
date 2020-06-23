//
//  ViewExtensions.swift
//  flexpom-macos
//
//  Created by Siri Tembunkiart on 6/23/20.
//  Copyright © 2020 stembunk. All rights reserved.
//

import Cocoa

extension NSView {
    func fixInView(_ container: NSView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    func getCenterPoint() -> CGPoint {
        return CGPoint(x: self.frame.origin.x + (self.frame.size.width / 2),
                       y: self.frame.origin.y + (self.frame.size.height / 2))
    }
}
