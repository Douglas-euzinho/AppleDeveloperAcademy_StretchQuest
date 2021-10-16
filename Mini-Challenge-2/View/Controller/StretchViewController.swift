//
//  StretchViewController.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 14/10/21.
//

import UIKit
import Core

class StretchViewController: UIViewController, OnStretchListener {
   
    
    // MARK: - Properties
    @IBOutlet weak var animation: UIImageView!
    @IBOutlet weak var descriptionStretch: UILabel!
    @IBOutlet weak var timerElipse: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var viewModel: StretchesViewModel!
    
    var timer: Timer?
    
    var agendamentos = 0
    var contador = 0
    
    var stretchDuration = 30
    
    func onStretchChanged(stretch: Stretch) {
        descriptionStretch.text = stretch.title
        self.contador = Int(stretch.durationInSeconds)
        self.timerLabel.text = "\(contador)"

            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    if self.agendamentos < 5 {
                        self.agendamentos += 1
                    } else {
                        self.timer?.invalidate()
                    }
            }
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.listener = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.startSession(with: .posture)
        self.startTimer()
    }
    
    @IBAction func presentPauseViewController() {
        showPauseViewController()
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    @objc func tick(){
        
        self.timerLabel.text = "\(contador)"
        contador -= 1

        if contador > -2 {
            
        }else{
            self.viewModel.nextStretch()
        }
    }
    
    func showPauseViewController() {
        let story = UIStoryboard(name: "Pause", bundle: nil)
        let pauseViewController = story.instantiateViewController(withIdentifier: "PauseViewController") as! PauseViewController
                
        timer?.invalidate()
        pauseViewController.delegate = self

        self.present(pauseViewController, animated: true, completion: nil)
    }
    
    func tock(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tick()
        }
    }
}


extension StretchViewController: PauseDelegate {
    
    func viewDidDisappear() {
        self.startTimer()
    }

}
