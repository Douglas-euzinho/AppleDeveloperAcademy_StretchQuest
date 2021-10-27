//
//  HardcodedStretchesRepository.swift
//  Mini-Challenge-2
//
//  Created by Iorgers Almeida on 26/10/21.
//

import Foundation
import Core

public class HardcodedStretchesRepository: StretchesRepository {

    public init () {}
    
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
                videoName: "sidebend2hands_right",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: false))
            
            //--
            
            //Shoulder stretch left
            list.append(Stretch(
                title: "Shoulder Stretch",
                instructions: "Stand tall with your shoulders relaxed and hold your arm above your elbow.",
                videoName: "sidebend2hands_right",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: false))
            
            // -- SKIP
            //Shoulder stretch right
            list.append(Stretch(
                title: "Shoulder Stretch",
                instructions: "Repeat the stretch on the other side",
                videoName: "sidebend2hands_right",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: true))
            
            // --
            
            //Neck Stretch Left
            list.append(Stretch(
                title: "Side Neck Stretch",
                instructions: "Place the arm on the affected side behind your back and use your other hand to draw your head towards the opposite side.",
                videoName: "sidebend2hands_right",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: false))
            
            // -- Skip
            
            //Neck Stretch Right
            list.append(Stretch(
                title: "Side Neck Stretch",
                instructions: "Repeat the stretch on the other side",
                videoName: "sidebend2hands_right",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: true))
            
            // --
            
            //Side Bend Left
            list.append(Stretch(
                title: "Side Bend",
                instructions: "Stand up straight with one arm straight overhead. Lean over to the side, taking the hand over the head",
                videoName: "sidebend2hands_right",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: false))
            
            // -- SKIP
            
            //Side Bend Right
            list.append(Stretch(
                title: "Side Bend",
                instructions: "Repeat the stretch on the other side",
                videoName: "sidebend2hands_right",
                durationInSeconds: 3,
                type: .posture,
                externalLink: nil,
                isContinuation: true))
            
            // --
        
            //Torso Twist Stretch
            list.append(Stretch(
                title: "Torso Twist",
                instructions: "Stand with your feet shoulder width apart. Put your hands in front of you with your elbows bent. Twist your upper body left and right.",
                videoName: "sidebend2hands_right",
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
