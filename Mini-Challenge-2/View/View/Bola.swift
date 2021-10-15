//
//  Bola.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 14/10/21.
//

import UIKit

@IBDesignable
class Bola: UIView {
    
    @IBInspectable var fillColor: UIColor = .black
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let circle = UIBezierPath(ovalIn: rect)
        
        fillColor.setFill()
        
        circle.fill()
    }
    
}
