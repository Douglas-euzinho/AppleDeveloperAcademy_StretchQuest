//
//  StretchSession.swift
//  Core
//
//  Created by Iorgers Almeida on 19/10/21.
//

import Foundation

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
