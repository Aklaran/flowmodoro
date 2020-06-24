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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let focusSession = FocusSession(pomodoroTime: Constants.POMODORO_TIME_SEC,
                                        shortBreakTime: Constants.SHORT_BREAK_TIME_SEC,
                                        longBreakTime: Constants.LONG_BREAK_TIME_SEC,
                                        cloverCount: Constants.CLOVER_COUNT)
        self.viewModel = ActiveFocusSessionViewModel(model: focusSession, view: sessionView)
        self.viewModel.delegate = self
    }
    
    @IBAction func timerClicked(_ sender: NSButton) {
        viewModel.startTiming()
    }
    
    @IBAction func resetClicked(_ sender: NSButton) {
        viewModel.stopTiming()
    }
}

extension ActiveFocusSessionViewController: ActiveFocusSessionViewModelDelegate {
    func viewModelHasNewData(_ viewModel: ActiveFocusSessionViewModel, from focusSession: FocusSession) {
        viewModel.configure(self.sessionView, toShow: focusSession)
        
        let shouldNotifyEndOfPom = !focusSession.isBreak &&
            (focusSession.pomodoroTimeSec - focusSession.currentFocusCounter == Constants.END_POM_NOTIF_BUFFER_S)
        let shouldNotifyEndOfBreak = focusSession.isBreak && focusSession.breakCounter == Constants.END_BREAK_NOTIF_BUFFER_S
        
        if shouldNotifyEndOfPom {
            NotificationManager.shared.showEndOfPomNotification()
            StatusBarContainer.shared.setPopoverContentViewController(viewModel: self.viewModel)
            StatusBarContainer.shared.showPopover(sender: self)
        }
        
        if shouldNotifyEndOfBreak {
            NotificationManager.shared.showEndOfBreakNotification()
        }
    }
}

