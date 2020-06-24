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
                
        return viewcontroller
    }
    
    @IBAction func focusButtonClicked(_ sender: NSButton) {
        // TODO: segue to ActiveFocusSessionViewController and start a new focus block
    }
    
    @IBAction func breakButtonClicked(_ sender: NSButton) {
        // TODO: segue to ActiveFocusSessionViewController and start a new break block
    }
}
