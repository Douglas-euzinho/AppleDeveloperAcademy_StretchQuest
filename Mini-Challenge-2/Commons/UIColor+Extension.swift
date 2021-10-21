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
                shapeColor: UIColor(red: 186/255, green: 24/255,  blue: 24/255,  alpha: 1),
                trackColor: UIColor(red: 229/255, green: 115/255, blue: 115/255, alpha: 1),
                shadowColor:UIColor(red: 220/255,  green: 20/255, blue: 60/255, alpha: 0.6),
                pulse:      UIColor(red: 232/255, green: 143/255,  blue: 143/255,  alpha: 0.6))
            
        case .posture:
            //Green Color
            return RingColorAttributes.init(
                shapeColor: UIColor(red: 25/255,   green: 185/255, blue: 23/255, alpha: 1),
                trackColor: UIColor(red: 117/255, green: 229/255, blue: 115/255, alpha: 1),
                shadowColor:UIColor(red: 30/255,  green: 144/255, blue: 155/255, alpha: 0.6),
                pulse:      UIColor(red: 155/255, green: 237/255, blue: 157/255, alpha: 0.6))
//
//            return RingColorAttributes.init(
//                shapeColor: UIColor(red: 0/255,   green: 206/255, blue: 209/255, alpha: 1),
//                trackColor: UIColor(red: 175/255, green: 238/255, blue: 238/255, alpha: 1),
//                shadowColor:UIColor(red: 30/255,  green: 144/255, blue: 155/255, alpha: 0.6),
//                pulse:      UIColor(red: 175/255, green: 238/255, blue: 250/255, alpha: 0.6))
            
        case .flexibility:
            //Blue Color
            return RingColorAttributes.init(
                shapeColor: UIColor(red: 23/255,   green: 64/255, blue: 255/255, alpha: 1),
                trackColor: UIColor(red: 115/255, green: 161/255, blue: 229/255, alpha: 1),
                shadowColor:UIColor(red: 0/255,   green: 191/255, blue: 255/255, alpha: 0.6),
                pulse:      UIColor(red: 154/255, green: 189/255, blue: 236/255, alpha: 0.6))
        }
        
    }
    
}
