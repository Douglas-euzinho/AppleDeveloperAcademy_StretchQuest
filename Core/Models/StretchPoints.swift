//
//  StretchPoints.swift
//  Core
//
//  Created by Iorgers Almeida on 19/10/21.
//

import Foundation

public struct StretchPoints {
    var strength: Int
    var posture: Int
    var flexibility: Int

    public static let empty = StretchPoints(strength: 0, posture: 0, flexibility: 0)
}
