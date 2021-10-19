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
    func started(with firstStretch: Stretch, totalOfStretches: Int) -> Void
}

public protocol StartStretchesSessionIteractor {
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

        result.started(
            with: stretchesSession.stretches.first!,
            totalOfStretches: stretches.reduce(0, { result, stretch in
                result + (stretch.hasContinuation ? 0 : 1)
            }))
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
                title: "Arms Up",
                instructions: "Bend your knees, lift your arms, interlace your fingers and move your arms from side to side",
                animation: [],
                durationInSeconds: 20,
                type: .posture,
                externalLink: nil,
                hasContinuation: false))
            
            //Shoulder stretch left
            list.append(Stretch(
                title: "Shoulder Stretch",
                instructions: "Stand tall with your shoulders relaxed and hold your arm above your elbow.",
                animation: [],
                durationInSeconds: 20,
                type: .posture,
                externalLink: nil,
                hasContinuation: true))
            //Shoulder stretch right
            list.append(Stretch(
                title: "Shoulder Stretch",
                instructions: "Repeat the stretch on the other side",
                animation: [],
                durationInSeconds: 20,
                type: .posture,
                externalLink: nil,
                hasContinuation: false))
            
            //Neck Stretch Left
            list.append(Stretch(
                title: "Side Neck Stretch",
                instructions: "Place the arm on the affected side behind your back and use your other hand to draw your head towards the opposite side.",
                animation: [],
                durationInSeconds: 20,
                type: .posture,
                externalLink: nil,
                hasContinuation: true))
            //Neck Stretch Right
            list.append(Stretch(
                title: "Side Neck Stretch",
                instructions: "Repeat the stretch on the other side",
                animation: [],
                durationInSeconds: 20,
                type: .posture,
                externalLink: nil,
                hasContinuation: false))
            
            //Side Bend Left
            list.append(Stretch(
                title: "Side Bend",
                instructions: "Stand up straight with one arm straight overhead. Lean over to the side, taking the hand over the head",
                animation: [],
                durationInSeconds: 20,
                type: .posture,
                externalLink: nil,
                hasContinuation: true))
            //Side Bend Right
            list.append(Stretch(
                title: "Side Bend",
                instructions: "Repeat the stretch on the other side",
                animation: [],
                durationInSeconds: 20,
                type: .posture,
                externalLink: nil,
                hasContinuation: false))
        
            //Torso Twist Stretch
            list.append(Stretch(
                title: "Torso Twist",
                instructions: "Stand with your feet shoulder width apart. Put your hands in front of you with your elbows bent. Twist your upper body left and right.",
                animation: [],
                durationInSeconds: 20,
                type: .posture,
                externalLink: nil,
                hasContinuation: false))
                        
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
