//
//  TimeBlock.swift
//  flexpom-macos
//
//  Created by Bo Tembunkiart on 6/23/20.
//  Copyright © 2020 stembunk. All rights reserved.
//

import Foundation

struct TimeBlock {
    let startTime: Date?
    var endTime: Date?
    let isBreak: Bool
    var duration: Int {
        guard let endTime = endTime, let startTime = startTime else {
            return 0
        }
        
        let duration = endTime.timeIntervalSince(startTime)
        return Int(round(duration))
    }
}
