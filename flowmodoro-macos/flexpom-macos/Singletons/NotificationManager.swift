//
//  NotificationManager.swift
//  flexpom-macos
//
//  Created by Siri  Tembunkiart on 3/30/20.
//  Copyright © 2020 stembunk. All rights reserved.
//

import Cocoa
import UserNotifications

class NotificationManager : NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        self.notificationCenter.delegate = self
        self.notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            guard error == nil else {
                print("\(String(describing: error?.localizedDescription))")
                return
            }
            print("Notification authorization granted: \(granted)")
        }
    }
    
    func showEndOfPomNotification() {
        let notification = UNMutableNotificationContent()
        notification.title = "Pom Completed"
        notification.subtitle = "Consider taking a break!"
        // FIXME: This sound won't play!
        notification.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "eventually.m4r"))
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: notification, trigger: nil)
        
        self.notificationCenter.add(request)
    }
    
    func showEndOfBreakNotification() {
        let notification = UNMutableNotificationContent()
        notification.title = "Break time's over!"
        notification.subtitle = "Go kill it bro."
        notification.sound = .default
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: notification, trigger: nil)
        
        self.notificationCenter.add(request)    }
}
