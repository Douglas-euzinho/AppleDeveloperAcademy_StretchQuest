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
            self.publishStretch()
            
            if !self.mustShowTransition {
                self.counter.start(initial: Int(currentStretch.durationInSeconds))
            }
        }
    }
    
    public var mustShowTransition: Bool {
        self.session.real.isFirst || !self.currentStretch.isContinuation
    }
    
    public var session: SessionProgress = SessionProgress.empty
    
    // MARK: View notifier
    
    var publishStretch: () -> () = {}
    
    var publishCountdown: (Int) -> () {
        get {
            self.counter.onPublishCountdown
        }
        
        set {
            self.counter.onPublishCountdown = newValue
        }
    }
    
    // MARK: Control properties
    
    var counter: CountdownTimer
    
    public init(category: StretchType){
        self.category = category
        self.startStretchesSession = StartStretchesSession(stretchesSessionRepository)
        self.startNextStretch = StartNextStretch(stretchesSessionRepository)
        self.counter = CountdownTimer()
        self.counter.onCountdownFinish = self.onCountdownFinish
    }
    
    public func startSession() {
        self.startStretchesSession.execute(with: self.category, result: self)
    }
    
    public func nextStretch() {
        self.startNextStretch.execute(result: self)
    }
    
    public func onCountdownFinish(){
        self.nextStretch()
    }
    
}

extension StretchesViewModel {
    
    func startCountdownTimer() {
        self.counter.start(initial: Int(currentStretch.durationInSeconds))
    }
    
    func resumeCountdownTimer(){
        self.counter.resume()
    }
    
    func pauseCountdownTime() {
        self.counter.pause()
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
