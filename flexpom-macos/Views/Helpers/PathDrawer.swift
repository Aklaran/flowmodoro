//
//  PathDrawer.swift
//  flexpom-macos
//
//  Created by Bo Tembunkiart on 6/26/20.
//  Copyright © 2020 stembunk. All rights reserved.
//

import Cocoa

struct PathDrawer {
    func drawArc(center: CGPoint,
                 radius: CGFloat,
                 lineWidth: CGFloat,
                 startAngle: CGFloat,
                 length: CGFloat,
                 color: NSColor) {
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
    
    func drawPolygonSegment(polygon: Polygon, lineWidth: CGFloat, color: NSColor, percentComplete: CGFloat) {
        print(percentComplete)
        let path = NSBezierPath()
        path.lineWidth = lineWidth
        path.lineCapStyle = .round
        color.setStroke()
        
        var points = [CGPoint]()

        for vertex in polygon.vertices {
            if vertex.percentOfShape <= percentComplete {
                points.append(vertex.coords)
            }
        }
        
        if points.count < polygon.vertices.count {
            let p1 = polygon.vertices[points.count - 1]
            let p2 = polygon.vertices[points.count]
            let segmentLength = p2.percentOfShape - p1.percentOfShape
            let percentOfSegment = (percentComplete - p1.percentOfShape) / segmentLength
            let x = p1.coords.x + (percentOfSegment * (p2.coords.x - p1.coords.x))
            let y = p1.coords.y + (percentOfSegment * (p2.coords.y - p1.coords.y))
            points.append(CGPoint(x: x, y: y))
        }
        
        path.move(to: points[0])
        for point in points[1...] {
            path.line(to: point)
            path.move(to: point)
        }
        
        path.stroke()
    }
}
