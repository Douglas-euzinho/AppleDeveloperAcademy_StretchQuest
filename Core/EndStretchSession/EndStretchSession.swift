//
//  EndStretchSession.swift
//  Core
//
//  Created by Iorgers Almeida on 14/10/21.
//

import Foundation

public protocol EndStretchSessionResult {
    func noCurrentSessionError() -> Void
}

extension EndStretchSessionResult {
    func noCurrentSessionError() {
        fatalError("EndStretchSession executed without a current session on repository")
    }
}

public protocol EndStretchSessionIteractor { // Atribuir o ponto referente ao tipo de alongamento
    func execute(result: EndStretchSessionResult) -> Void
}

public class EndStretchSession: EndStretchSessionIteractor {

    let sessionsRepository: StretchesSessionRepository

    public init(
        _ sessionsRepository: StretchesSessionRepository
    ){
        self.sessionsRepository = sessionsRepository
    }

    public func execute(result: EndStretchSessionResult) {

        guard
            let currentSession = self.sessionsRepository.getCurrentSession()
        else {
            return result.noCurrentSessionError()
        }

        let updatedSession = StretchSession(
            start: currentSession.start,
            end: Date.now,
            stretches: currentSession.stretches,
            currentStretch: currentSession.currentStretch,
            type: currentSession.type,
            pointIncrement: currentSession.pointIncrement)

        self.sessionsRepository.updateCurrentSession(to: updatedSession)
    }

}
