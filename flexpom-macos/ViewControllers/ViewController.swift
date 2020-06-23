//
//  ViewController.swift
//  flexpom-macos
//
//  Created by Siri  Tembunkiart on 12/13/19.
//  Copyright © 2019 stembunk. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var sessionView: ActiveFocusSessionView!
    
    var viewModel: ActiveFocusSessionViewModel!
    
    static func freshController() -> ViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("ViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
            fatalError("Why cant i find ViewController? - Check Main.storyboard")
        }
                
        return viewcontroller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let focusSession = FocusSession(pomodoroTime: Constants.POMODORO_TIME_SEC,
                                        shortBreakTime: Constants.SHORT_BREAK_TIME_SEC,
                                        longBreakTime: Constants.LONG_BREAK_TIME_SEC,
                                        cloverCount: Constants.CLOVER_COUNT)
        self.viewModel = ActiveFocusSessionViewModel(model: focusSession, view: sessionView)
    }
    
    @IBAction func timerClicked(_ sender: NSButton) {
        viewModel.startTiming() { newTitle in
            sender.title = newTitle
        }
    }
    
    @IBAction func resetClicked(_ sender: NSButton) {
        viewModel.stopTiming()
    }
}

