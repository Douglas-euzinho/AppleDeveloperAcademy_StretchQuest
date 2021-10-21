//
//  OnCategoryViewModel.swift
//  Mini-Challenge-2
//
//  Created by Iorgers Almeida on 14/10/21.
//

import Foundation
import Core

public class StretchesViewModel {
    
    // MARK: Dependencies
    
    let stretchesSessionRepository:
        StretchesSessionRepository = FakeStretchesSessionRepository()
    
    let startStretchesSession: StartStretchesSessionIteractor
    let startNextStretch: StartNextStretchIteractor
    
    // MARK: Published properties
    
    public let category: StretchType
    
    public var currentStretch: Stretch = Stretch.empty {
        didSet {
            self.countdown = Int(currentStretch.durationInSeconds)
            self.publishStretch()
            self.publishCountdown()
            
            if !self.mustShowTransition {
                self.startCountdownTimer()
            }
        }
    }
    
    public var mustShowTransition: Bool {
        self.session.real.isFirst || !self.currentStretch.isContinuation
    }
    
    public var session: SessionProgress = SessionProgress.empty
    
    // MARK: View notifier
    
    var publishStretch: () -> () = {}
    var publishCountdown: () -> () = {}
    
    // MARK: Control properties
    
    var timer: Timer?
    var countdown = 0
    
    public init(category: StretchType){
        self.category = category
        self.startStretchesSession = StartStretchesSession(stretchesSessionRepository)
        self.startNextStretch = StartNextStretch(stretchesSessionRepository)
    }
    
    public func startSession() {
        self.startStretchesSession.execute(with: self.category, result: self)
    }
    
    public func nextStretch() {
        self.startNextStretch.execute(result: self)
    }
    
}

extension StretchesViewModel {
    
    @objc func timerTick() {
        
        self.countdown -= 1
        
        if self.countdown == -1 {
            self.pauseCountdownTime()
            self.startNextStretch.execute(result: self)
            return
        }else{
            self.publishCountdown()
        }
    }
    
    func startCountdownTimer() {
        print("[StrechesViewModel] startCountdownTimer()")
        self.timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timerTick),
            userInfo: nil,
            repeats: true)
    }
    
    func resumeCountdownTimer(){
        print("[StrechesViewModel] resumeCountdownTimer()")
        self.startCountdownTimer()
    }
    
    func pauseCountdownTime() {
        print("[StrechesViewModel] pauseCountdownTimer()")
        self.timer?.invalidate()
    }
    
}

extension StretchesViewModel: StartStretchesSessionResult {
    
    public func started(with firstStretch: Stretch, progress: SessionProgress) {
        self.session = progress
        self.currentStretch = firstStretch
    }
}

extension StretchesViewModel: StartNextStretchResult {
    public func sessionDidFinish() {
        print("[StretchesViewModel] Session did Finish!!!")
    }
    
    public func next(stretch: Stretch, progress: SessionProgress) {
        self.session = progress
        self.currentStretch = stretch
    }
}
