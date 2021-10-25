//
//  StretchSession.swift
//  Core
//
//  Created by Iorgers Almeida on 19/10/21.
//

import Foundation

public struct StretchSession {

    public let start: Date
    public let end: Date?
    public let stretches: [Stretch]
    public let currentStretch: Int
    public let type: StretchType
    public let pointIncrement: Int

    public init(
        start: Date,
        end: Date?,
        stretches: [Stretch],
        currentStretch: Int,
        type: StretchType,
        pointIncrement: Int
    ) {
        self.start = start
        self.end = end
        self.stretches = stretches
        self.currentStretch = currentStretch
        self.type = type
        self.pointIncrement = pointIncrement
    }

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
