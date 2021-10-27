//
//  StartStretchesSession.swift
//  Core
//
//  Created by Iorgers Almeida on 13/10/21.
//

import Foundation

public protocol StretchesRepository {
    func list(filterBy type: StretchType) -> [Stretch]
}

public protocol StartStretchesSessionResult {
    func started(with firstStretch: Stretch, progress: SessionProgress) -> Void
}

public protocol StartStretchesSessionIteractor {
    func execute(with stretchType: StretchType, result: StartStretchesSessionResult) -> Void
}

public class StartStretchesSession: StartStretchesSessionIteractor {

    let sessionsRepository: StretchesSessionRepository
    let stretchesRepository: StretchesRepository

    public init (
        _ sessionsRepository: StretchesSessionRepository,
        _ stretchesRepository: StretchesRepository
    ) {
       self.sessionsRepository = sessionsRepository
       self.stretchesRepository = stretchesRepository
    }

    public func execute(with stretchType: StretchType, result: StartStretchesSessionResult) {

        let stretches = self.stretchesRepository.list(filterBy: stretchType)

        let stretchesSession = StretchSession(
            start: Date.now,
            end: nil,
            stretches: stretches,
            currentStretch: 0,
            type: stretchType,
            pointIncrement: 1)

        self.sessionsRepository.add(session: stretchesSession)

        let stretchesWithTransition = stretches.reduce(0, { result, stretch in
            result + (stretch.isContinuation ? 0 : 1)
        })

        result.started(
            with: stretches.first!,
            progress: SessionProgress(
                totalReal: stretches.count,
                totalAparent: stretchesWithTransition
            ))
    }
}

