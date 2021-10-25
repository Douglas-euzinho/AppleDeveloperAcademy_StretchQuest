//
//  CountownTimer.swift
//  Mini-Challenge-2
//
//  Created by Iorgers Almeida on 22/10/21.
//

import Foundation

class CountdownTimer {
    
    var timer: Timer?
    var countdown = 0 {
        didSet {
            if self.countdown >= 0 {
                self.onPublishCountdown(self.countdown)
            }
        }
    }
    
    var onCountdownFinish: () -> () = {}
    var onPublishCountdown: (Int) -> () = { number in }
    
    public init () {}
    
    @objc func timerTick() {
        
        self.countdown -= 1
        
        if self.countdown == -1 {
            self.pause()
            self.onCountdownFinish()
        }
    }
    
    func start(initial value: Int) {
        print("[CountdownTimer] start(initial:)")
        self.countdown = value
        self.timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timerTick),
            userInfo: nil,
            repeats: true)
    }
    
    func resume(){
        print("[CountdownTimer] resume() \(String(describing: self.timer?.isValid))")
        self.timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timerTick),
            userInfo: nil,
            repeats: true)
    }
    
    func pause() {
        print("[CountdownTimer] pause()")
        self.timer?.invalidate()
    }
    
}
