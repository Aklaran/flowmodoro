//
//  StatusBarContainer.swift
//  flexpom-macos
//
//  Created by Bo Tembunkiart on 6/24/20.
//  Copyright © 2020 stembunk. All rights reserved.
//

import Cocoa

class StatusBarContainer: NSObject, NSMenuDelegate {
    static let shared = StatusBarContainer()
    
    private var eventMonitor: EventMonitor?
    
    private var statusBarItem: NSStatusItem
    private var statusBarMenu: NSMenu
    
    private var popover: NSPopover
    
    private override init() {
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.statusBarMenu = NSMenu(title: "Status Bar Menu")
        self.popover = NSPopover()

        super.init()
        
        // Set status bar item image
        let image = NSImage(named: "RippedTimer")
        image?.isTemplate = true
        self.statusBarItem.button?.image = image
        
        // Allow taps on status bar
        self.statusBarItem.button?.target = self
        self.statusBarItem.button?.action = #selector(self.statusBarButtonClicked(_:))
        self.statusBarItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        
        // initialize right-click menu
        self.statusBarMenu.delegate = self
        self.statusBarMenu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        // Set the default content view for the popover
        self.popover.contentViewController = ActiveFocusSessionViewController.freshController()
        
        // Initialize event monitor to detect for clicks outside of popover
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self]
            event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }
    
    @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        if event.type == NSEvent.EventType.rightMouseUp {
            statusBarItem.menu = statusBarMenu // add menu to button...
            statusBarItem.button?.performClick(nil) // ...and click it
        } else {
            togglePopover(self)
        }
    }
    
    func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusBarItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        
        eventMonitor?.start()
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        
        eventMonitor?.stop()
    }
    
    func setPopoverContentViewController<T: NSViewController>(_ controller: T) {
        self.popover.contentViewController = controller
    }
    
    @objc func menuDidClose(_ menu: NSMenu) {
        statusBarItem.menu = nil // remove menu so button displays default behavior
    }
}
