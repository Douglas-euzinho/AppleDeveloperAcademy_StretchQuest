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
    func next(stretch: Stretch) -> Void
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

        let newSession = StretchSession(
            start: currentSession.start,
            end: currentSession.end,
            stretches: currentSession.stretches,
            currentStretch: currentStretchIndex,
            type: currentSession.type,
            pointIncrement: currentSession.pointIncrement)

        // TODO: Refactor to handle the index out of range situation
        let next = currentSession.stretches[currentStretchIndex % newSession.stretches.count]

        self.repository.updateCurrentSession(to: newSession)
        
        result.next(stretch: next)
    }

}
