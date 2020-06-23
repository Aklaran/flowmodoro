//
//  PomodoroTimer.swift
//  flexpom-macos
//
//  Created by Bo Tembunkiart on 10/30/19.
//  Copyright © 2019 Siri Tembunkiart. All rights reserved.
//

import Foundation

class PomodoroTimer {
    static let shared = PomodoroTimer()
    
    private var timer: Timer?
    private var observations = [ObjectIdentifier: Observation]()
    
    private init() {}
    
    func start() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            for (id, observation) in self.observations {
                // If the observer is no longer in memory, clean up
                guard let observer = observation.observer else {
                    self.observations.removeValue(forKey: id)
                    continue
                }
                
                observer.timerDidFire(self)
            }
        }
    }
    
    func stop() {
        self.timer?.invalidate()
        self.timer = nil
    }
}


// MARK: - Observable


protocol TimerObserver: class {
    func timerDidFire(_ timer: PomodoroTimer)
}

private extension PomodoroTimer {
    struct Observation {
        weak var observer: TimerObserver?
    }
}

extension PomodoroTimer {
    func addObserver(_ observer: TimerObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }
    
    func removeObserver(_ observer: TimerObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
}
