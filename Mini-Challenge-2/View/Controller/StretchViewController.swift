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
    
    var contador = 0 {
        didSet {
            self.timerLabel.text = "\(contador)"
        }
    }
    
    var stretchDuration = 30
    
    let shape = CAShapeLayer()
    var circlePath = UIBezierPath()

    
    func onStretchChanged(stretch: Stretch) {
        descriptionStretch.text = stretch.title
        self.contador = Int(stretch.durationInSeconds)
        self.timerLabel.text = "\(contador)"
        
        self.startTimerAnimation()
        self.ringTimerAnimation()
        

        if self.agendamentos < 5 {
            self.agendamentos += 1
        } else {
            self.timer?.invalidate()
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
        self.timer?.tolerance = 0
    }
    
    func startTimerAnimation() {
        
        let label = self.view.subviews.first { view in
            return type(of: view) == UILabel.self
        }
        
        guard label != nil else { return }
         
        self.circlePath = UIBezierPath.init(arcCenter: label!.center, radius: 75, startAngle: 0, endAngle: .pi*2, clockwise: true)
        
        let trackShape          = CAShapeLayer()
        trackShape.path         = circlePath.cgPath
        trackShape.fillColor    = UIColor.clear.cgColor
        trackShape.lineWidth    = 15
        trackShape.cornerRadius = 15
        trackShape.strokeColor  = UIColor.lightGray.cgColor
        
        view.layer.addSublayer(trackShape)
        
        shape.path         = circlePath.cgPath
        shape.lineWidth    = 15
        shape.strokeColor  = UIColor.green.cgColor
        shape.cornerRadius = 15
        shape.fillColor    = UIColor.clear.cgColor
        shape.strokeEnd    = 0
        
        view.layer.addSublayer(shape)
    }
    
    func ringTimerAnimation() {
        let startAnimate = CABasicAnimation(keyPath: "strokeEnd")
        startAnimate.toValue = 1
        startAnimate.duration = CFTimeInterval(self.contador)
        startAnimate.isRemovedOnCompletion = false
        startAnimate.fillMode = .forwards
        
        shape.add(startAnimate, forKey: "animation")
    }
    
    func pauseRingAnimation() {
        let pausedTime = shape.convertTime(CACurrentMediaTime(), from: nil)
        shape.speed = 0
        shape.timeOffset = pausedTime
    }
    
    func resumeRingAnimation() {
        let pausedTime = shape.timeOffset
        
        shape.speed = 1
        shape.timeOffset = 0
        shape.beginTime = 0
        
        let timeSincePause = shape.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        print(timeSincePause)
        shape.beginTime = timeSincePause
    }
    
    @objc func tick(){
        contador -= 1

        if contador == -1 {
            self.viewModel.nextStretch()
        }
    }
    
    func showPauseViewController() {
        let story = UIStoryboard(name: "Pause", bundle: nil)
        let pauseViewController = story.instantiateViewController(withIdentifier: "PauseViewController") as! PauseViewController
        
        timer?.invalidate()
        pauseRingAnimation()
        pauseViewController.delegate = self

        self.present(pauseViewController, animated: true, completion: nil)
    }
}

extension StretchViewController: PauseDelegate {
    
    func viewDidDisappear() {
        self.startTimer()
        self.resumeRingAnimation()
    }

}
