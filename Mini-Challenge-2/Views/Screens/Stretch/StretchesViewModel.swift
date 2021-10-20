//
//  OnCategoryViewModel.swift
//  Mini-Challenge-2
//
//  Created by Iorgers Almeida on 14/10/21.
//

import Foundation
import Core

public protocol OnStretchListener: AnyObject {
    func onStretchChanged(stretch: Stretch, progress: SessionProgress) -> Void
}

public class StretchesViewModel {
    
    let category: StretchType
    
    let stretchesSessionRepository:
        StretchesSessionRepository = FakeStretchesSessionRepository()
    
    let startStretchesSession: StartStretchesSessionIteractor
    let startNextStretch: StartNextStretchIteractor
    
    var listener: OnStretchListener?
    
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

extension StretchesViewModel: StartStretchesSessionResult {
    
    public func started(with firstStretch: Stretch, totalOfStretches: Int) {
        self.listener?.onStretchChanged(
            stretch: firstStretch,
            progress: SessionProgress(total: totalOfStretches))
    }
}

extension StretchesViewModel: StartNextStretchResult {
    public func next(stretch: Stretch, progress: SessionProgress) {
        self.listener?.onStretchChanged(stretch: stretch, progress: progress)
    }
}
