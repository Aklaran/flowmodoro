//
//  ActiveFocusSessionViewModel.swift
//  flexpom-macos
//
//  Created by Bo Tembunkiart on 6/23/20.
//  Copyright © 2020 stembunk. All rights reserved.
//

import Foundation
import Cocoa

class ActiveFocusSessionViewModel {
    let model: FocusSession
    
    weak var delegate: ActiveFocusSessionViewModelDelegate? {
        didSet {
            delegate?.viewModelHasNewData(self, from: self.model)
        }
    }
    
    private var isCurrentlyShowingBreak: Bool = false
    
    init(model: FocusSession, view: ActiveFocusSessionView?) {
        self.model = model
        self.model.delegate = self
    }
    
    // Model commands
    
    func startFocus() {
        self.model.beginFocusBlock()
        PomodoroTimer.shared.addObserver(self.model)
    }
    
    func startBreak() {
        self.model.beginBreakBlock()
        PomodoroTimer.shared.addObserver(self.model)
    }
    
    func startTiming() {
        self.model.beginNextBlock()
        PomodoroTimer.shared.addObserver(self.model)
    }
    
    func pauseTiming() {
        PomodoroTimer.shared.removeObserver(self.model)
    }
        
    func stopTiming() {
        // TODO: save the model to persistent store & scrap it
        self.model.reset()
        PomodoroTimer.shared.removeObserver(self.model)
    }
    
    // View configuration
    
    func configure(_ view: ActiveFocusSessionView, toShow session: FocusSession) {
        let focusTimeString = self.formatFocusString(counter: session.currentFocusCounter)
        let breakTimeString = self.formatBreakString(counter: session.totalBreakCounter)
        let focusArcDeg = self.calculateFocusArc(currentCount: session.currentFocusCounter, totalCount: session.pomodoroTimeSec)
        let breakArcDeg = self.calculateBreakArc(currentCount: session.totalBreakCounter, totalCount: session.pomodoroTimeSec)
        
        if session.isBreak != self.isCurrentlyShowingBreak {
            if session.isBreak {
                let startAngle = ActiveFocusSessionView.DEFAULT_START_ANGLE - CGFloat(session.percentBreakRemaining * 360)
                if startAngle != view.startAngleDeg {
                    view.startAngleDeg = startAngle
                    view.generatePolygons(isBreak: true)
                }
            } else {
                if ActiveFocusSessionView.DEFAULT_START_ANGLE != view.startAngleDeg {
                    view.startAngleDeg = ActiveFocusSessionView.DEFAULT_START_ANGLE
                    view.generatePolygons(isBreak: false)
                }
            }
            self.isCurrentlyShowingBreak = session.isBreak
        }
        
        view.focusTimeLabel.stringValue = focusTimeString
        view.breakTimeLabel.stringValue = breakTimeString
        view.focusPercentage = CGFloat(session.percentFocusRemaining)
        view.breakPercentage = CGFloat(session.percentBreakRemaining)
        view.focusArcDeg = focusArcDeg
        view.breakArcDeg = breakArcDeg
        view.pomLabel.stringValue = "Poms: \(session.numPoms)"
        view.cloverLabel.stringValue = "Clovers: \(session.numClovers)"
        view.focusButton.title = session.isBreak ? "Focus" : "Break"
        
        view.needsDisplay = true
    }
    
    func configure(_ view: TransitionDecisionView, toShow session: FocusSession) {
        view.breakButton.title = "Break (\(formatBreakString(counter: session.totalBreakCounter)))"
    }
    
    private func formatFocusString(counter: Int) -> String {
        let focusSecondsRemaining = model.pomodoroTimeSec - counter
        return self.convertCountToTimeString(counter: focusSecondsRemaining)
    }
    
    private func formatBreakString(counter: Int) -> String {
        if counter < 0 {
            return "-" + self.convertCountToTimeString(counter: counter * -1)
        } else {
            return self.convertCountToTimeString(counter: counter)
        }
    }
    
    private func convertCountToTimeString(counter: Int) -> String {
        let seconds = counter % 60
        let minutes = counter / 60
        
        var secondsString = "\(seconds)"
        var minutesString = "\(minutes)"
        
        if seconds < 10 {
            secondsString = "0" + secondsString
        }
        
        if minutes < 10 {
            minutesString = "0" + minutesString
        }
        
        return "\(minutesString):\(secondsString)"
    }
    
    private func calculateFocusArc(currentCount: Int, totalCount: Int) -> CGFloat {
        let elapsedCount = totalCount - currentCount
        let percentRemaining: Double = Double(elapsedCount) / Double(totalCount)
        return CGFloat(percentRemaining * 360)
    }
    
    private func calculateBreakArc(currentCount: Int, totalCount: Int) -> CGFloat {
        let percentFilled: Double = Double(currentCount) / Double(totalCount)
        return CGFloat(percentFilled * 360)
    }
}

extension ActiveFocusSessionViewModel: ActiveFocusSessionDelegate {
    func focusSessionDidUpdateState(_ focusSession: FocusSession) {
        self.delegate?.viewModelHasNewData(self, from: focusSession)
    }
    
    func focusSessionDidTerminate(_ focusSession: FocusSession) {
        self.stopTiming()
    }
}

protocol ActiveFocusSessionViewModelDelegate: class {
    func viewModelHasNewData(_ viewModel: ActiveFocusSessionViewModel, from focusSession: FocusSession)
}
