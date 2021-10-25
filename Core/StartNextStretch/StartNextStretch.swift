//
//  StartNextStretch.swift
//  Core
//
//  Created by Iorgers Almeida on 14/10/21.
//

import Foundation

public protocol StartNextStretchIteractor {
    func execute(result: StartNextStretchResult) -> Void 
}

public protocol StartNextStretchResult {
    func next(stretch: Stretch, progress: SessionProgress) -> Void
    func sessionDidFinish() -> Void
}

public class StartNextStretch: StartNextStretchIteractor {

    let repository: StretchesSessionRepository

    public init(
        _ repository: StretchesSessionRepository
    ){
        self.repository = repository
    }

    public func execute(result: StartNextStretchResult) -> Void {

        let currentSession = self.repository.list().last!

        let currentStretchIndex = currentSession.currentStretch + 1

        if currentStretchIndex == currentSession.stretches.count {
            return result.sessionDidFinish()
        }
        
        let newSession = StretchSession(
            start: currentSession.start,
            end: currentSession.end,
            stretches: currentSession.stretches,
            currentStretch: currentStretchIndex,
            type: currentSession.type,
            pointIncrement: currentSession.pointIncrement)

        let next = currentSession.stretches[currentStretchIndex]

        self.repository.updateCurrentSession(to: newSession)
        
        let currentStretch = newSession
            .stretches[0..<currentStretchIndex]
            .filter({!$0.isContinuation}).count + 1
        
        let realProgress = TaskProgress(
            currentStretchIndex + 1,
            newSession.stretches.count
        )
        
        let aparentProgress = TaskProgress(
            currentStretch,
            newSession.stretches.reduce(0, { result, stretch in
                result + (stretch.isContinuation ? 0 : 1)
            })
        )
        
        let progression = SessionProgress(
            real: realProgress,
            aparent: aparentProgress)
        
        result.next(stretch: next, progress: progression)
    }

}

public class StartNextStretchEndSession: StartNextStretchIteractor {
    
    public init() {}
    
    public func execute(result: StartNextStretchResult) {
        result.sessionDidFinish()
    }
    
}
