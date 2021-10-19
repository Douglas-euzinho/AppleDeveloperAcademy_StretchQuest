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
        "Stretch: \(self.title) has continuation: \(self.hasContinuation)"
    }
    
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
