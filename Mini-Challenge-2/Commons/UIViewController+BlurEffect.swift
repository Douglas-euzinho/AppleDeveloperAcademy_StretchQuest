//
//  UIViewController+BlurEffect.swift
//  Mini-Challenge-2
//
//  Created by Iorgers Almeida on 28/10/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func applyBlur(style blurEffect: UIBlurEffect = UIBlurEffect(style: .light)) {
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = UIScreen.main.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        blurEffectView.restorationIdentifier = "blurEffectView"
        
        self.view.addSubview(blurEffectView)
    }

    func removeBlur() {
        let toRemove = self.view.subviews.filter({
            $0.restorationIdentifier ?? "" == "blurEffectView"
        })
        
        toRemove.forEach({
            $0.removeFromSuperview()
        })
    }
    
}
