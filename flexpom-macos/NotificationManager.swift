//
//  NotificationManager.swift
//  flexpom-macos
//
//  Created by Siri  Tembunkiart on 3/30/20.
//  Copyright © 2020 stembunk. All rights reserved.
//

import Cocoa

class NotificationManager : NSObject, PomodoroTimerDelegate, NSUserNotificationCenterDelegate {
  let timer: PomodoroTimer!
  let notificationCenter = NSUserNotificationCenter.default
  
  public init (timer: PomodoroTimer) {
    self.timer = timer

    super.init()
    
    self.timer.delegates.append(self)
    notificationCenter.delegate = self
  }
  
  func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
    return true
  }
  
  func didReceiveUpdate(isBreak: Bool, focusTimeDisplay: String, breakTimeDisplay: String, numPoms: Int, numClovers: Int) {
    if focusTimeDisplay == "0:05" {
      showEndOfPomNotification()
  } else if breakTimeDisplay == "0:05" {
      showEndOfBreakNotification()
    }
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
