//
//  ActiveFocusSessionViewController.swift
//  flexpom-macos
//
//  Created by Bo Tembunkiart on 12/13/19.
//  Copyright © 2019 stembunk. All rights reserved.
//

import Cocoa

class ActiveFocusSessionViewController: NSViewController {
    @IBOutlet weak var sessionView: ActiveFocusSessionView!
    
    var viewModel: ActiveFocusSessionViewModel!
    
    static func freshController() -> ActiveFocusSessionViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("ActiveFocusSessionViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ActiveFocusSessionViewController else {
            fatalError("Why cant i find ViewController? - Check Main.storyboard")
        }
                
        return viewcontroller
    }
    
    static func freshController(viewModel: ActiveFocusSessionViewModel) -> ActiveFocusSessionViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("ActiveFocusSessionViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ActiveFocusSessionViewController else {
            fatalError("Why cant i find ViewController? - Check Main.storyboard")
        }
        
        viewcontroller.viewModel = viewModel
                
        return viewcontroller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // only set the viewmodel if it's nil because we want to
        // keep the viewModel from freshController(viewModel:) if it exists
        if self.viewModel == nil {
            let focusSession = FocusSession(pomodoroTime: Constants.POMODORO_TIME_SEC,
                                            shortBreakTime: Constants.SHORT_BREAK_TIME_SEC,
                                            longBreakTime: Constants.LONG_BREAK_TIME_SEC,
                                            cloverCount: Constants.CLOVER_COUNT)
            self.viewModel = ActiveFocusSessionViewModel(model: focusSession, view: sessionView)
        }
        
        self.viewModel.delegate = self

    }
    
    @IBAction func timerClicked(_ sender: NSButton) {
        viewModel.startTiming()
    }
    
    @IBAction func resetClicked(_ sender: NSButton) {
        viewModel.stopTiming()
    }
    
    func segueToTransitionVC() {
        let transitionVC = TransitionDecisionViewController.freshController(viewModel: self.viewModel)
        
        // showPopover needs to be called before setting the contentVC so the popover will resize properly
        StatusBarContainer.shared.showPopover(sender: self)
        StatusBarContainer.shared.setPopoverContentViewController(transitionVC)
    }
}

extension ActiveFocusSessionViewController: ActiveFocusSessionViewModelDelegate {
    func viewModelHasNewData(_ viewModel: ActiveFocusSessionViewModel, from focusSession: FocusSession) {
        viewModel.configure(self.sessionView, toShow: focusSession)
        
        let isEndOfPom = !focusSession.isBreak && focusSession.currentFocusCounter == focusSession.pomodoroTimeSec
        
        let isAlmostEndOfBreak = focusSession.isBreak && focusSession.totalBreakCounter == Constants.END_BREAK_NOTIF_BUFFER_S

        if isEndOfPom {
            self.viewModel.pauseTiming()
            NotificationManager.shared.showEndOfPomNotification()
            self.segueToTransitionVC()
        }
        
        if isAlmostEndOfBreak {
            NotificationManager.shared.showEndOfBreakNotification()
            StatusBarContainer.shared.showPopover(sender: self)
        }
    }
}

