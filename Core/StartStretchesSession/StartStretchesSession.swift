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
    func started(with firstStretch: Stretch) -> Void
}

public protocol StartStretchesSessionIteractor {
    //func execute(with: StretchType) -> Void
    func execute(with stretchType: StretchType, result: StartStretchesSessionResult) -> Void
}

public class StartStretchesSession: StartStretchesSessionIteractor {

    let sessionsRepository: StretchesSessionRepository
    let stretchesRepository: StretchesRepository = HardcodedStretchesRepository()

    public init (_ repository: StretchesSessionRepository) {
       self.sessionsRepository = repository
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

        result.started(with: stretchesSession.stretches.first!)
    }
}

public class HardcodedStretchesRepository: StretchesRepository {

    public func list(filterBy type: StretchType) -> [Stretch] {

        var list = [Stretch]()

        switch(type){

        case .flexibility:
            list.append(Stretch.sideBend)
            list.append(Stretch.sideBend)
            list.append(Stretch.sideBend)
            list.append(Stretch.sideBend)
            list.append(Stretch.sideBend)

        case .posture:
            list.append(Stretch(
                title: "Torso Twist",
                instructions: "Leia a Bula",
                animation: [],
                durationInSeconds: 7,
                type: .flexibility,
                externalLink: nil))

            list.append(Stretch(
                title: "Shoulder Stretch",
                instructions: "Leia a Bula",
                animation: [],
                durationInSeconds: 7,
                type: .flexibility,
                externalLink: nil))

            list.append(Stretch.sideBend)
            list.append(Stretch.sideBend)
            list.append(Stretch.sideBend)

        case .strength:
            list.append(Stretch.sideBend)
            list.append(Stretch.sideBend)
            list.append(Stretch.sideBend)
            list.append(Stretch.sideBend)
            list.append(Stretch.sideBend)
        }

        return list
    }

}
