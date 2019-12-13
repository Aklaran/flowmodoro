//
//  PomodoroTimer.swift
//  flexpom-macos
//
//  Created by Siri  Tembunkiart on 10/30/19.
//  Copyright © 2019 Siri Tembunkiart. All rights reserved.
//

import Foundation
import Combine

class PomodoroTimer: ObservableObject {
  static let POM_THRESH = 1500 // seconds needed to achieve a pom
  static let SHORT_BREAK = 300 // this gets modulo'd to determine how fast breaktime is gained
  static let LONG_BREAK = 600 // 10 extra minutes for clover break
  static let CLOVER_COUNT = 4 // number of poms per clover
  
  weak var delegate: PomodoroTimerDelegate?
  
  var timer: Timer?
  
  var totalCounter: Int = 0
  var currentCounter: Int = 0
  var breakCounter: Int = 0
  
  var isBreak: Bool = true
  
  var focusTimeDisplay = PomodoroTimer.formatFocusString(counter: 0)
  var breakTimeDisplay = "00:00"
  
  var numPoms = 0
  var numClovers = 0
  
  func startFocus() {
    self.timer?.invalidate()
    
    self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      self.updateCounters(increment: 1)
    }
    
    self.isBreak = false
  }
  
  func startBreak() {
    self.timer?.invalidate()
    
    // reset current time so we get a fresh pom. total time is saved in totalCounter
    self.currentCounter = 0
    
    self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      self.updateCounters(increment: 1)
    }
    
    self.isBreak = true
  }
  
  private func updateCounters(increment: Int) {
    isBreak ? updateBreakCounter(increment: increment) : updateFocusCounter(increment: increment)
    
    delegate?.didReceiveUpdate(isBreak: isBreak, focusTimeDisplay: focusTimeDisplay, breakTimeDisplay: breakTimeDisplay, numPoms: numPoms, numClovers: numClovers)
  }
  
  private func updateFocusCounter(increment: Int) {
    self.totalCounter += increment
    self.currentCounter += increment
    
    let break_ratio = PomodoroTimer.POM_THRESH / PomodoroTimer.SHORT_BREAK
    
    // give the equivalent of 5 min break for 25 min focus
    if self.currentCounter % break_ratio == 0 {
      self.breakCounter += 1
    }
    
    if self.totalCounter % PomodoroTimer.POM_THRESH == 0 {
      self.numPoms += 1
      
      self.currentCounter = 1
      
      if self.numPoms % PomodoroTimer.CLOVER_COUNT == 0 {
        self.numClovers += 1
        self.breakCounter += PomodoroTimer.LONG_BREAK
      }
      
      self.startFocus()
    }
    
    self.updateDisplays()
  }
  
  private func updateBreakCounter(increment: Int) {
    self.breakCounter -= 1
    
    self.updateDisplays()
  }
  
  func reset() {
    self.resetCounters()
    self.isBreak = true
    timer?.invalidate()
    
    delegate?.didReceiveUpdate(isBreak: isBreak, focusTimeDisplay: focusTimeDisplay, breakTimeDisplay: breakTimeDisplay, numPoms: numPoms, numClovers: numClovers)
  }
  
  private func resetCounters() {
    self.currentCounter = 0
    self.totalCounter = 0
    self.breakCounter = 0
    self.numPoms = 0
    self.numClovers = 0
    self.updateDisplays()
  }
  
  private func updateDisplays() {
    self.focusTimeDisplay = PomodoroTimer.formatFocusString(counter: self.currentCounter)
    self.breakTimeDisplay = PomodoroTimer.formatBreakString(counter: self.breakCounter)
  }
  
  static func formatFocusString(counter: Int) -> String {
    let focusSecondsRemaining = PomodoroTimer.POM_THRESH - counter
    return PomodoroTimer.convertCountToTimeString(counter: focusSecondsRemaining)
  }
  
  static func formatBreakString(counter: Int) -> String {
    if counter < 0 {
      return "-" + PomodoroTimer.convertCountToTimeString(counter: counter * -1)
    } else {
      return PomodoroTimer.convertCountToTimeString(counter: counter)
    }
  }
  
  static func convertCountToTimeString(counter: Int) -> String {
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
}

protocol PomodoroTimerDelegate: class {
  
  func didReceiveUpdate(isBreak: Bool, focusTimeDisplay: String, breakTimeDisplay: String, numPoms: Int, numClovers: Int)

}
