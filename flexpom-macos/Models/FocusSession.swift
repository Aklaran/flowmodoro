//
//  FocusSession.swift
//  flexpom-macos
//
//  Created by Bo Tembunkiart on 6/23/20.
//  Copyright © 2020 stembunk. All rights reserved.
//

import Foundation

class FocusSession {
    weak var delegate: ActiveFocusSessionDelegate?
    
    // Injected configuration constants
    
    let pomodoroTimeSec: Int //  The time threshold needed to achieve 1 pomodoro
    let shortBreakTimeSec: Int // length of short breaks
    let longBreakTimeSec: Int // length added for long breaks
    let cloverCount: Int // number of pomodoros within 1 session needed to get a long break
    
    // Calculated variables
    
    private var breakRatio: Int {
        // Convoluted casting to get the number of seconds of focus time that grants 1 second of break time
        // Rounded to the nearest int
        Int(round(Double(pomodoroTimeSec) / Double(shortBreakTimeSec)))
    }
    
    // State variables
    
    private(set) var totalFocusCounter: Int = 0 // The total time spent focusing in the session
    private(set) var currentFocusCounter: Int = 0 // The time spent focusing in the current focus block
    private(set) var breakCounter: Int = 0 // The accumulated break time remaining in the session
    
    private(set) var isBreak: Bool = true
    
    private(set) var numPoms = 0
    private(set) var numClovers = 0
    
    // Stored variables

    private var timeBlocks = [TimeBlock]() {
        didSet {
            print(timeBlocks.count)
        }
    }
    private var currentTimeBlock: TimeBlock?
    
    init(pomodoroTime: Int, shortBreakTime: Int, longBreakTime: Int, cloverCount: Int) {
        self.pomodoroTimeSec = pomodoroTime
        self.shortBreakTimeSec = shortBreakTime
        self.longBreakTimeSec = longBreakTime
        self.cloverCount = cloverCount
    }
    
    func reset() {
        // save the current block before we wipe the slate
        self.commitBlock()
        
        // wipe the slate
        self.currentFocusCounter = 0
        self.totalFocusCounter = 0
        self.breakCounter = 0
        self.numPoms = 0
        self.numClovers = 0
        self.isBreak = true
        
        delegate?.focusSessionDidUpdateState(self)
    }
    
    func beginBlock() {
        if self.currentTimeBlock != nil {
            self.commitBlock()
        }
        
        self.isBreak = !self.isBreak
        
        if self.isBreak {
            self.currentFocusCounter = 0
        }
        
        self.currentTimeBlock = TimeBlock(startTime: Date(), endTime: nil, isBreak: self.isBreak)
        
        print("\(isBreak ? "Break" : "Focus") block initiated at \(String(describing: currentTimeBlock?.startTime))")
    }
    
    func commitBlock() {
        guard var currentTimeBlock = self.currentTimeBlock else {
            print("Failed to commit time block because none is initialized.")
            return
        }
        
        currentTimeBlock.endTime = Date()
        self.timeBlocks.append(currentTimeBlock)
        print("\(currentTimeBlock.isBreak ? "Break" : "Focus") block committed at \(String(describing: currentTimeBlock.endTime))")
        
        self.currentTimeBlock = nil
    }
}

extension FocusSession: TimerObserver {
    func timerDidFire(_ timer: PomodoroTimer) {
        // Assuming that the timer will fire every 1 second
        isBreak ? updateBreakCounter(increment: 1) : updateFocusCounter(increment: 1)
        
        delegate?.focusSessionDidUpdateState(self)
    }
    
    private func updateFocusCounter(increment: Int) {
        self.totalFocusCounter += increment
        self.currentFocusCounter += increment

        // Add to the break counter such that, at the end of focusTimeSec seconds, shortBreakTimeSec seconds of break time
        // will have been accumulated.
        if self.currentFocusCounter % self.breakRatio == 0 {
            self.breakCounter += 1
        }
        
        // Award a pom if the total focus time of the session reaches the threshold
        if self.totalFocusCounter % self.pomodoroTimeSec == 0 {
            self.numPoms += 1
            
            // Award a clover if the number of poms achieved in the session reaches the threshold
            if self.numPoms % self.cloverCount == 0 {
                self.numClovers += 1
                self.breakCounter += self.longBreakTimeSec
            }
        }
        
        // Record the focus block
        // And transition to a new break block
        if self.currentFocusCounter % self.pomodoroTimeSec == 0 {
            self.commitBlock()
            self.beginBlock()
            
            // FIXME: No hook to update the Focus button label, so it stays on "Break"
        }
    }
    
    private func updateBreakCounter(increment: Int) {
        // Unlike the focus counters, break counter counts down from the accumulated break time to 0.
        self.breakCounter -= 1
        
        if self.breakCounter < 0 {
            delegate?.focusSessionDidTerminate(self)
        }
    }
}

protocol ActiveFocusSessionDelegate: class {
    func focusSessionDidUpdateState(_ focusSession: FocusSession)
    func focusSessionDidTerminate(_ focusSesssion: FocusSession)
}
