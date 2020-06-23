//
//  NotificationManager.swift
//  flexpom-macos
//
//  Created by Siri  Tembunkiart on 3/30/20.
//  Copyright © 2020 stembunk. All rights reserved.
//

import Cocoa

class NotificationManager : NSObject, NSUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    let notificationCenter = NSUserNotificationCenter.default
    
    private override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    func showEndOfPomNotification() {
        let notification = NSUserNotification()
        notification.title = "Pom Completed"
        notification.subtitle = "Consider taking a break!"
        notification.soundName = NSUserNotificationDefaultSoundName
        
        notificationCenter.deliver(notification)
    }
    
    func showEndOfBreakNotification() {
        let notification = NSUserNotification()
        notification.title = "Break time's over!"
        notification.subtitle = "Go kill it bro."
        notification.soundName = NSUserNotificationDefaultSoundName
        
        notificationCenter.deliver(notification)
    }
}
