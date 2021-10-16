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
        self.contador = Int(stretch.durationInSeconds)
        self.timerLabel.text = "\(contador)"
        
        let story = UIStoryboard(name: "Pause", bundle: nil)
        
        let pausa = story.instantiateViewController(withIdentifier: "PauseViewController")
        
        self.present(pausa, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                pausa.dismiss(animated: true){
                    if self.agendamentos < 5 {
                        self.agendamentos += 1
                        self.tick()
                    }
                }
            }
        }
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.listener = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.startSession(with: .posture)
    }
    
    func tick(){
        self.timerLabel.text = "\(contador)"
        contador -= 1
        
        if contador > -2 {
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
