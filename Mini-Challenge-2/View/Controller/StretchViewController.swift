//
//  StretchViewController.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 14/10/21.
//

import UIKit
import Core

class StretchViewController: UIViewController, OnStretchListener{
 
    // MARK: - Properties
    @IBOutlet weak var animation: UIImageView!
    @IBOutlet weak var descriptionStretch: UILabel!
    @IBOutlet weak var timerElipse: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var viewModel: StretchesViewModel!
    
    var agendamentos = 0
    var contador = 0
    
    var stretchDuration = 30
    
    func onStretchChanged(stretch: Stretch) {
        descriptionStretch.text = stretch.title
        self.stretchDuration = Int(stretch.durationInSeconds)
        
        if agendamentos < 5 {
            agendamentos += 1
            tick()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.listener = self
        self.viewModel.startSession(with: .posture)
    }
    
    func tick(){
        
        contador += 1
        contador = contador % (self.stretchDuration + 1)
        
        self.timerLabel.text = "\(contador)"
        
        if contador < self.stretchDuration {
            tock()
        }else{
            self.viewModel.nextStretch()
        }
    }
    
    func tock(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tick()
        }
    }
}
