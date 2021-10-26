//
//  Stretch.swift
//  Core
//
//  Created by Iorgers Almeida on 19/10/21.
//

import Foundation
import UIKit

public struct Stretch: CustomStringConvertible {
    public var description: String {
        "Stretch: \(self.title) has continuation: \(self.isContinuation)"
    }
    
    public let title: String
    public let instructions: String
    public let videoName: String
    public let durationInSeconds: Float
    public let type: StretchType
    public let externalLink: URL?
    public var isContinuation: Bool

    public static let sideBend = Stretch(
        title: "Side Bend",
        instructions: "DO IT",
        videoName: "sidebend2hands_right",
        durationInSeconds: 30.0,
        type: .posture,
        externalLink: nil,
        isContinuation: false)

    public static let empty = Stretch (
        title: "",
        instructions: "",
        videoName: "test",
        durationInSeconds: 0.0,
        type: .posture,
        externalLink: nil,
        isContinuation: false
    )
}
