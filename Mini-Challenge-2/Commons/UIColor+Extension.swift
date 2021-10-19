//
//  UIColor+Extension.swift
//  Mini-Challenge-2
//
//  Created by Daniel Gomes Ribeiro on 18/10/21.
//

import UIKit
import Core

extension UIColor {
    
    static func getColorBy(category: StretchType) -> RingColorAttributes {
        
        switch category {
            
        case .strength:
            //Red Color
            return RingColorAttributes.init(
                shapeColor: UIColor(red: 220/255, green: 20/255,  blue: 60/255,  alpha: 1),
                trackColor: UIColor(red: 240/255, green: 128/255, blue: 128/255, alpha: 1),
                shadowColor:UIColor(red: 220/255,  green: 20/255, blue: 60/255, alpha: 0.6),
                pulse:      UIColor(red: 220/255, green: 20/255,  blue: 60/255,  alpha: 0.6))
            
        case .posture:
            //Green Color
            return RingColorAttributes.init(
                shapeColor: UIColor(red: 0/255,   green: 206/255, blue: 209/255, alpha: 1),
                trackColor: UIColor(red: 175/255, green: 238/255, blue: 238/255, alpha: 1),
                shadowColor:UIColor(red: 30/255,  green: 144/255, blue: 155/255, alpha: 0.6),
                pulse:      UIColor(red: 175/255, green: 238/255, blue: 250/255, alpha: 0.6))
            
        case .flexibility:
            //Blue Color
            return RingColorAttributes.init(
                shapeColor: UIColor(red: 0/255,   green: 191/255, blue: 255/255, alpha: 1),
                trackColor: UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 1),
                shadowColor:UIColor(red: 0/255,   green: 191/255, blue: 255/255, alpha: 0.6),
                pulse:      UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 0.6))
        }
        
    }
    
}
