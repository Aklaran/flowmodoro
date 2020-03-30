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
  
  public init (timer: PomodoroTimer) {
    self.timer = timer

    super.init()
    
    self.timer.delegates.append(self)
  }
  
  func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
    return true
  }
  
  func showNotification() {
    let notification = NSUserNotification()
    notification.title = "Test."
    notification.subtitle = "Sub Test."
    notification.soundName = NSUserNotificationDefaultSoundName
    NSUserNotificationCenter.default.delegate = self
    NSUserNotificationCenter.default.deliver(notification)
  }

  
  func didReceiveUpdate(isBreak: Bool, focusTimeDisplay: String, breakTimeDisplay: String, numPoms: Int, numClovers: Int) {
    if focusTimeDisplay == "24:55" {
      showNotification()
    }
  }
}
