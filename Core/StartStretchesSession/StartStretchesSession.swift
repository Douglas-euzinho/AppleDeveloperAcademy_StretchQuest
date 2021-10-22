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
            
            //---
            
            list.append(Stretch(
                title: "Arms Up",
                instructions: "Bend your knees, lift your arms, interlace your fingers and move your arms from side to side",
                videoName: "test",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: false))
            
            //--
            
            //Shoulder stretch left
            list.append(Stretch(
                title: "Shoulder Stretch",
                instructions: "Stand tall with your shoulders relaxed and hold your arm above your elbow.",
                videoName: "test",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: false))
            
            // -- SKIP
            //Shoulder stretch right
            list.append(Stretch(
                title: "Shoulder Stretch",
                instructions: "Repeat the stretch on the other side",
                videoName: "test",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: true))
            
            // --
            
            //Neck Stretch Left
            list.append(Stretch(
                title: "Side Neck Stretch",
                instructions: "Place the arm on the affected side behind your back and use your other hand to draw your head towards the opposite side.",
                videoName: "test",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: false))
            
            // -- Skip
            
            //Neck Stretch Right
            list.append(Stretch(
                title: "Side Neck Stretch",
                instructions: "Repeat the stretch on the other side",
                videoName: "test",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: true))
            
            // --
            
            //Side Bend Left
            list.append(Stretch(
                title: "Side Bend",
                instructions: "Stand up straight with one arm straight overhead. Lean over to the side, taking the hand over the head",
                videoName: "test",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: false))
            
            // -- SKIP
            
            //Side Bend Right
            list.append(Stretch(
                title: "Side Bend",
                instructions: "Repeat the stretch on the other side",
                videoName: "test",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: true))
            
            // --
        
            //Torso Twist Stretch
            list.append(Stretch(
                title: "Torso Twist",
                instructions: "Stand with your feet shoulder width apart. Put your hands in front of you with your elbows bent. Twist your upper body left and right.",
                videoName: "test",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: false))
            
            // -- FIM
                        
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
