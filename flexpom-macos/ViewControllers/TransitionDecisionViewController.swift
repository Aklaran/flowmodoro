//
//  TransitionDecisionViewController.swift
//  flexpom-macos
//
//  Created by Bo Tembunkiart on 6/24/20.
//  Copyright © 2020 stembunk. All rights reserved.
//

import Cocoa

class TransitionDecisionViewController: NSViewController {
    @IBOutlet weak var transitionView: TransitionDecisionView!
    
    var viewModel: ActiveFocusSessionViewModel!
    
    var decisionTimer: Timer?
    
    static func freshController(viewModel: ActiveFocusSessionViewModel) -> TransitionDecisionViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("TransitionDecisionViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? TransitionDecisionViewController else {
            fatalError("Why cant i find ViewController? - Check Main.storyboard")
        }
        
        viewcontroller.viewModel = viewModel
        
        return viewcontroller
    }
    
    override func viewDidLoad() {
        self.viewModel.delegate = self
        
        self.startDecisionTimeout()
    }
    
    private func startDecisionTimeout() {
        // After TRANSITION_TIME sec, will automatically start a break and go back.
        self.decisionTimer = Timer.scheduledTimer(withTimeInterval: Constants.TRANSITION_TIME_S, repeats: false) { _ in
            self.viewModel.startBreak()
            self.segueToActiveSessionVC()
        }
    }
    
    @IBAction func focusButtonClicked(_ sender: NSButton) {
        self.viewModel.startFocus()
        self.segueToActiveSessionVC()
    }
    
    @IBAction func breakButtonClicked(_ sender: NSButton) {
        self.viewModel.startBreak()
        self.segueToActiveSessionVC()
    }
    
    func segueToActiveSessionVC() {
        self.decisionTimer?.invalidate()
        let sessionVC = ActiveFocusSessionViewController.freshController(viewModel: self.viewModel)
        
        // showPopover needs to be called before setting the contentVC so the popover will resize properly
        StatusBarContainer.shared.showPopover(sender: self)
        StatusBarContainer.shared.setPopoverContentViewController(sessionVC)
    }
}

extension TransitionDecisionViewController: ActiveFocusSessionViewModelDelegate {
    func viewModelHasNewData(_ viewModel: ActiveFocusSessionViewModel, from focusSession: FocusSession) {
        self.viewModel.configure(self.transitionView, toShow: focusSession)
    }
}
