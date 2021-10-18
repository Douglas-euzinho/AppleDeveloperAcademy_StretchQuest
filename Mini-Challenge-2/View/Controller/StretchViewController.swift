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
    
    let shape      = CAShapeLayer()
    let trackShape = CAShapeLayer()
    var circlePath = UIBezierPath()
    var pulsatingLayer = CAShapeLayer()

    
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
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        
        let label = self.view.subviews.first { view in
            return type(of: view) == UILabel.self
        }
                
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 75, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = UIColor(red: 175/255, green: 238/255, blue: 250/255, alpha: 0.6).cgColor
        layer.lineWidth = 10
        layer.fillColor = fillColor.cgColor
        layer.lineCap = .round
        layer.position = label!.center
        return layer
    }
    
    func startTimerAnimation() {
        
        let label = self.view.subviews.first { view in
            return type(of: view) == UILabel.self
        }
        
        guard label != nil else { return }
         
        self.circlePath = UIBezierPath.init(arcCenter: label!.center, radius: 75, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        pulsatingLayer = createCircleShapeLayer(strokeColor: .green, fillColor: UIColor.clear)
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        trackShape.path         = circlePath.cgPath
        trackShape.fillColor    = UIColor.clear.cgColor
        trackShape.lineWidth    = 15
        trackShape.strokeColor  = UIColor(red: 175/255, green: 238/255, blue: 238/255, alpha: 1).cgColor
        
        view.layer.addSublayer(trackShape)


//        trackShape.strokeColor  = UIColor(red: 102/255, green: 255/255, blue: 0/255, alpha: 0.2).cgColor
     
        
        
        shape.path         = circlePath.cgPath
        shape.lineWidth    = 15
        shape.strokeColor  = UIColor(red: 0/255, green: 206/255, blue: 209/255, alpha: 1).cgColor
        shape.lineCap      = .round
        shape.fillColor    = UIColor.clear.cgColor
        shape.strokeEnd    = 0
        
        view.layer.addSublayer(shape)
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.15
        animation.duration = 1.7
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    func ringTimerAnimation() {
        let startAnimate      = CABasicAnimation(keyPath: "strokeEnd")
        
        startAnimate.toValue  = 1
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
        shape.beginTime = timeSincePause
    }
    
    @objc func tick(){
        contador -= 1
        
        if contador == -1 {
            self.view.layer.removeAnimation(forKey: "transform.scale")
            self.pulsatingLayer.removeFromSuperlayer()
            self.trackShape.removeFromSuperlayer()
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
//
//extension UIView {
//
//  func addShadow() {
//     self.backgroundColor = UIColor.clear
//     let roundedShapeLayer = CAShapeLayer()
//     let roundedMaskPath = UIBezierPath(roundedRect: self.bounds,
//                                       byRoundingCorners: [.topLeft, .bottomLeft, .bottomRight],
//                                       cornerRadii: CGSize(width: 8, height: 8))
//
//     roundedShapeLayer.frame = self.bounds
//     roundedShapeLayer.fillColor = UIColor.white.cgColor
//     roundedShapeLayer.path = roundedMaskPath.cgPath
//
//     self.layer.insertSublayer(roundedShapeLayer, at: 0)
//
//     self.layer.shadowOpacity = 0.4
//     self.layer.shadowOffset = CGSize(width: -0.1, height: 4)
//     self.layer.shadowRadius = 3
//     self.layer.shadowColor = UIColor.lightGray.cgColor
//   }
//}
