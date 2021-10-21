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
    
    lazy var circleAttributed = UIColor.getColorBy(category: viewModel.category) //Retorna o attributed                                                                         de acordo com a categoria
    
    var timer: Timer?
    
    var agendamentos = 0
    
    var contador = 0 {
        didSet {
            self.timerLabel.text = "\(contador)"
        }
    }
    
    var stretchDuration = 30
    
    //Ring properties
    var pulsatingLayer = CAShapeLayer()
    let shape          = CAShapeLayer()
    let trackShape     = CAShapeLayer()
    var circlePath     = UIBezierPath()

    
    func onStretchChanged(stretch: Stretch, progress: SessionProgress) {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.circlePath = UIBezierPath.init(arcCenter: timerLabel.center, radius: timerLabel.frame.width, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        pulsatingLayer.path = UIBezierPath(arcCenter: .zero, radius: timerLabel.frame.width, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
        trackShape.path         = circlePath.cgPath
        shape.path         = circlePath.cgPath
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.startSession()
        self.startTimer()
    }
    
    @IBAction func presentPauseViewController() {
        showPauseViewController()
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        self.timer?.tolerance = 0
    }
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor, radius: CGFloat) -> CAShapeLayer {
        
        let label = self.view.subviews.first { view in
            return type(of: view) == UILabel.self
        }
                
        let layer = CAShapeLayer()
        let circularPath  = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        layer.path        = circularPath.cgPath
        layer.strokeColor = self.circleAttributed.pulse.cgColor
        layer.lineWidth   = 16
        layer.fillColor   = fillColor.cgColor
        layer.lineCap     = .round
        layer.position    = label!.center
        return layer
    }
    
    func startTimerAnimation() {
        
        let label = self.view.subviews.first { view in
            return type(of: view) == UILabel.self
        }
        
        guard label != nil else { return }
         
        self.circlePath = UIBezierPath.init(arcCenter: label!.center, radius: label!.intrinsicContentSize.width, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        pulsatingLayer = createCircleShapeLayer(strokeColor: .green, fillColor: UIColor.clear, radius: label!.intrinsicContentSize.width)
        view.layer.addSublayer(pulsatingLayer)
        
        animatePulsatingLayer()
                    
        view.addShadow(layer: trackShape, path: self.circlePath, color: circleAttributed.shadowColor)
        
        trackShape.path         = circlePath.cgPath
        trackShape.fillColor    = UIColor.clear.cgColor
        trackShape.lineWidth    = 15
        trackShape.strokeColor  = circleAttributed.trackColor.cgColor
        view.layer.addSublayer(trackShape)

        shape.path         = circlePath.cgPath
        shape.lineWidth    = 15
        shape.strokeColor  = circleAttributed.shapeColor.cgColor
        shape.lineCap      = .round
        shape.fillColor    = UIColor.clear.cgColor
        shape.strokeEnd    = 0
        view.layer.addSublayer(shape)
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue        = 1.2
        animation.duration       = 2.2
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses   = true
        animation.repeatCount    = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    func ringTimerAnimation() {
        
        let startAnimate      = CABasicAnimation(keyPath: "strokeEnd")
        
        startAnimate.toValue  = 1
        startAnimate.duration = CFTimeInterval(self.contador)
        startAnimate.fillMode = .forwards
        startAnimate.isRemovedOnCompletion = false
     
        shape.add(startAnimate, forKey: "animation")
    }
    
    func pauseRingAnimation() {
        let pausedTime   = shape.convertTime(CACurrentMediaTime(), from: nil)
        shape.speed      = 0
        shape.timeOffset = pausedTime
    }
    
    func resumeRingAnimation() {
        let pausedTime = shape.timeOffset
        
        shape.speed      = 1
        shape.timeOffset = 0
        shape.beginTime  = 0
        
        let timeSincePause = shape.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shape.beginTime    = timeSincePause
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

extension UIView {
    func addShadow(layer: CALayer, path: UIBezierPath, color: UIColor) {
      
     layer.backgroundColor = UIColor.clear.cgColor
     let roundedShapeLayer = CAShapeLayer()

     roundedShapeLayer.frame = self.bounds
     roundedShapeLayer.fillColor = UIColor.clear.cgColor
     roundedShapeLayer.path = path.cgPath
        
     layer.insertSublayer(roundedShapeLayer, at: 0)
     layer.shadowOpacity = 1
     layer.shadowOffset  = CGSize(width: 0, height: 0)
     layer.shadowRadius  = 5
     layer.shadowColor   = color.cgColor

   }
}
