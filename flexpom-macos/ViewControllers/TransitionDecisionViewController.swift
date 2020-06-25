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
        viewcontroller.viewModel.delegate = viewcontroller
                
        return viewcontroller
    }
    
    @IBAction func focusButtonClicked(_ sender: NSButton) {
        viewModel.startFocus()
        self.segueToActiveSessionVC()
    }
    
    @IBAction func breakButtonClicked(_ sender: NSButton) {
        viewModel.startBreak()
        self.segueToActiveSessionVC()
    }
    
    func segueToActiveSessionVC() {
        let sessionVC = ActiveFocusSessionViewController.freshController(viewModel: self.viewModel)
        StatusBarContainer.shared.setPopoverContentViewController(sessionVC)
    }
}

extension TransitionDecisionViewController: ActiveFocusSessionViewModelDelegate {
    func viewModelHasNewData(_ viewModel: ActiveFocusSessionViewModel, from focusSession: FocusSession) {
        // TODO: Set break time remaining string
    }
}
