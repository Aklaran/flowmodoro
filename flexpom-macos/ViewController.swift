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
  @IBOutlet weak var pomLabel: NSTextField!
  @IBOutlet weak var cloverLabel: NSTextField!

  
  @IBOutlet weak var timerButton: NSButton!
  
  var timer: PomodoroTimer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    timer.delegates.append(self)
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
    
    pomLabel.stringValue = "Poms: " + String(numPoms)
    cloverLabel.stringValue = "Clovers: " + String(numClovers)
  }
}

extension ViewController {
  // MARK: Storyboard instantiation
  static func freshController(timer: PomodoroTimer) -> ViewController {
    //1.
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    //2.
    let identifier = NSStoryboard.SceneIdentifier("ViewController")
    //3.
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
      fatalError("Why cant i find ViewController? - Check Main.storyboard")
    }
    
    viewcontroller.timer = timer
    
    return viewcontroller
  }
}

