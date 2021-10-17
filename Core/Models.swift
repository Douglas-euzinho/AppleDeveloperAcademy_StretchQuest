//
//  Entities.swift
//  Core
//
//  Created by Iorgers Almeida on 13/10/21.
//

import Foundation
import UIKit

public enum StretchType {
    case strength
    case posture
    case flexibility
}

public struct Stretch {
    public let title: String
    public let instructions: String
    public let animation: [UIImage]
    public let durationInSeconds: Float
    public let type: StretchType
    public let externalLink: URL?
    public var hasContinuation: Bool

    public static let sideBend = Stretch(
        title: "Side Bend",
        instructions: "DO IT",
        animation: [],
        durationInSeconds: 30.0,
        type: .posture,
        externalLink: nil,
        hasContinuation: false)
}

public struct StretchPoints {
    var strength: Int
    var posture: Int
    var flexibility: Int

    public static let empty = StretchPoints(strength: 0, posture: 0, flexibility: 0)
}

public struct StretchSession {
    let start: Date
    let end: Date?
    let stretches: [Stretch]
    let currentStretch: Int
    let type: StretchType
    let pointIncrement: Int

    public static let posture =
        StretchSession(
            start: Date(timeIntervalSinceNow: 0),
            end: nil,
            stretches: [Stretch.sideBend],
            currentStretch: 0,
            type: .posture,
            pointIncrement: 1
        )

    public static let flexibility =
        StretchSession(
            start: Date(timeIntervalSinceNow: 0),
            end: nil,
            stretches: [],
            currentStretch: 0,
            type: .flexibility,
            pointIncrement: 1
        )

    public static let strength =
        StretchSession(
            start: Date(timeIntervalSinceNow: 0),
            end: nil,
            stretches: [],
            currentStretch: 0,
            type: .strength,
            pointIncrement: 1
        )

}
