//
//  SOunds.swift
//  Mini-Challenge-2
//
//  Created by Douglas Figueirôa on 28/10/21.
//

import Foundation
import UIKit
import AVFoundation

class Sounds{
    static var sharedS = Sounds()
    
    var audio: AVAudioPlayer?
    var volume: Bool!
    
    
    func playSoundStretchDid(){
        let path = Bundle.main.path(forResource: "StretchDid", ofType: ".mp3")!
        let url = URL(fileURLWithPath: path)
        
        do{
            self.audio = try AVAudioPlayer(contentsOf: url)
            self.audio!.play()
        }catch{
            print("deu ruim mano")
        }
        
    }
    
    func playSoundSessionStretchDid(){
        let path = Bundle.main.path(forResource: "StretchSessionDid", ofType: ".mp3")!
        let url = URL(fileURLWithPath: path)
        
        do{
            self.audio = try AVAudioPlayer(contentsOf: url)
            self.audio!.play()
        }catch{
            print("deu erro mano")
        }
        
    }
    
    func pauseSound(){
        self.audio?.pause()
    }
}
