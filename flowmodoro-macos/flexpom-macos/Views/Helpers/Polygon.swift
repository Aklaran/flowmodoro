//
//  Polygon.swift
//  flexpom-macos
//
//  Created by Bo Tembunkiart on 6/27/20.
//  Copyright © 2020 stembunk. All rights reserved.
//

import Cocoa

struct Polygon {
    var vertices: [Vertex]
    
    init(sides: Int,
         center: CGPoint,
         radius: CGFloat,
         startAngleDeg: CGFloat,
         isClockwise: Bool) {
        // if we want to go counter-clockwise, we need to take the negative in all our trig functions
        let clockMult: CGFloat = isClockwise ? -1 : 1
        // If we're taking the negatives of all of our trig functions, we need to start on the
        // opposite side of the shape
        let startAngleRad = isClockwise ? startAngleDeg.asRadians() - .pi : startAngleDeg.asRadians()
        
        var items = [Vertex]()
        for i in 0..<sides {
            let trigFactor = clockMult * (startAngleRad + 2 * CGFloat(i) * .pi / CGFloat(sides))
            
            let x = center.x + (radius * cos(trigFactor))
            let y = center.y + (radius * sin(trigFactor))
            
            let coords = CGPoint(x: x, y: y)
            let percentOfShape = CGFloat(i) / CGFloat(sides)
            items.append(Vertex(coords: coords, percentOfShape: percentOfShape))
        }
        
        // Add the first vertex to the end to close out the shape
        items.append(Vertex(coords: items[0].coords, percentOfShape: 1))
        
        self.vertices = items
    }
}

struct Vertex {
    let coords: CGPoint
    let percentOfShape: CGFloat
}

extension CGFloat {
    func asRadians() -> CGFloat {
        return self * .pi / 180
    }
}
