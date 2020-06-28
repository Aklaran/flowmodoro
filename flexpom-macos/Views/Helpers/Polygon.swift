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
         isClockwise: Bool) {
        // For ease of maths, this is restricted to only having the start angle be 90deg straight up for now.
        let vertexAngle: CGFloat = 2 * CGFloat.pi / CGFloat(sides)

        var items = [Vertex]()
        for i in 0..<sides {
            // if we want to go counter-clockwise, we need to multiply all x-coords by -1.
            let xMult: CGFloat = isClockwise ? 1 : -1
            let x = center.x + (xMult * (radius * sin(CGFloat(i) * vertexAngle)))
            let y = center.y + radius * cos(CGFloat(i) * vertexAngle)
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
