//
//  SetOrientation.swift
//  Mini-Challenge-2
//
//  Created by Daniel Gomes Ribeiro on 25/10/21.
//

import UIKit

public struct SetOrientation {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
}
