//
//  ViewController.swift
//  flexpom-macos
//
//  Created by Siri  Tembunkiart on 12/13/19.
//  Copyright © 2019 stembunk. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

  @IBOutlet weak var focusLabel: NSTextField!
  @IBOutlet weak var breakLabel: NSTextField!
  
  @IBOutlet weak var timerButton: NSButton!
  
  var timer: PomodoroTimer?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    timer = PomodoroTimer()
    timer?.delegate = self
  }
  
  @IBAction func timerClicked(_ sender: NSButton) {
    guard let timer = timer else {
      print("no timer initialized")
      return
    }
    
    timer.isBreak ? timer.startFocus() : timer.startBreak()
  }
  
  @IBAction func resetClicked(_ sender: NSButton) {
    guard let timer = timer else {
      print("no timer initialized")
      return
    }
    
    timer.reset()
  }
}

extension ViewController: PomodoroTimerDelegate {
  func didReceiveUpdate(isBreak: Bool, focusTimeDisplay: String, breakTimeDisplay: String, numPoms: Int, numClovers: Int) {
    timerButton.title = isBreak ? "Focus" : "Break"
    focusLabel.stringValue = focusTimeDisplay
    breakLabel.stringValue = breakTimeDisplay
  }
}

