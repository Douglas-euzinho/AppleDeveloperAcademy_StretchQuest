//
//  TransitionViewModel.swift
//  Mini-Challenge-2
//
//  Created by Iorgers Almeida on 20/10/21.
//

import Foundation
import Core

class TransitionViewModel {
    
    public var transitionLenghtInSeconds: Int = 5
    public var onPublished: (() -> ())? = {}
    public var counter: Int = 0
    public var didFinish: Bool = false
    public var category: StretchType = .strength
    
    var timer: Timer?
    
    func start() {
        self.counter = self.transitionLenghtInSeconds
        self.timer =
            Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(tick),
                userInfo: nil,
                repeats: true)
    }
    
    @objc func tick() {
        if self.counter == 0 {
            self.didFinish = true
            self.timer?.invalidate()
            self.onPublished?()
            return
        }
        
        self.counter -= 1
        self.onPublished?()
    }
    
}
