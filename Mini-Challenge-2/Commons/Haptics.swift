//
//  Haptics.swift
//  Mini-Challenge-2
//
//  Created by Daniel Gomes Ribeiro on 25/10/21.
//

import UIKit

final class Haptics {
    
    static let share = Haptics()
    
    private init(){}
    
    public func selectionVibrate(){
        DispatchQueue.main.async {
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.prepare()
            selectionFeedbackGenerator.selectionChanged()
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType){
        DispatchQueue.main.async {
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(type)
        }
    }
    
    @objc public func vibrateSuccess(){
        Haptics.share.vibrate(for: .success)
    }
    
    @objc public func vibrateError(){
        Haptics.share.vibrate(for: .error)
    }
    
    @objc public func vibrateWarning(){
        Haptics.share.vibrate(for: .warning)
    }
}
