//
//  OnCategoryViewModel.swift
//  Mini-Challenge-2
//
//  Created by Iorgers Almeida on 14/10/21.
//

import Foundation
import Core

public protocol OnStretchListener: AnyObject {
    func onStretchChanged(stretch: Stretch) -> Void
}

public class StretchesViewModel {
    
    let stretchesSessionRepository:
        StretchesSessionRepository = FakeStretchesSessionRepository()
    
    let startStretchesSession: StartStretchesSessionIteractor
    let startNextStretch: StartNextStretchIteractor
    
    var listener: OnStretchListener?
    
    init(){
        self.startStretchesSession = StartStretchesSession(stretchesSessionRepository)
        self.startNextStretch = StartNextStretch(stretchesSessionRepository)
    }
    
    func startSession(with stretchType: StretchType) {
        self.startStretchesSession.execute(with: stretchType, result: self)
    }
    
    func nextStretch() {
        self.startNextStretch.execute(result: self)
    }
    
}

extension StretchesViewModel: StartStretchesSessionResult {
    public func started(with firstStretch: Stretch) {
        self.listener?.onStretchChanged(stretch: firstStretch)
        //self.viewController.currentStretch = firstStretch
    }
}

extension StretchesViewModel: StartNextStretchResult {
    public func next(stretch: Stretch) {
        self.listener?.onStretchChanged(stretch: stretch)
        //self.viewController.currentStretch = stretch
    }
}
