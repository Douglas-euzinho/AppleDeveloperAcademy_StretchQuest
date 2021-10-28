//
//  TransitionViewController.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 18/10/21.
//

import UIKit
import AVKit
import Core


typealias OnDismiss = () -> ()

class TransitionViewController: UIViewController {
    
    
    @IBOutlet weak var videoTransitionView: UIView!
    @IBOutlet weak var descriptionTransition: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    lazy var circleAttributed = UIColor.getColorBy(category: self.viewModel.category)
    
    lazy var transitionColor = UIColor.getTransitionRingColor()
    
    var pulsatingLayer = CAShapeLayer()
    public let shape          = CAShapeLayer()
    public let trackShape     = CAShapeLayer()
    var circlePath     = UIBezierPath()
    
    public let stretchVideoController = AVPlayerViewController()
    
    var currentStretch: Stretch!
    
    var counterLabel: UILabel!
    var viewModel: TransitionViewModel! = TransitionViewModel()
    var onDismiss: OnDismiss?
    
    var ringAlreadySetuped: Bool = false
    var fieldsAlreadySet: Bool = false
    
    lazy var onPublished: () -> () = {
        self.counterLabel.text = "\(self.viewModel.counter)"
        
        if self.viewModel.didFinish {
            self.dismiss(animated: true)
        }
    }
    
    func setFieldsForCurrentStretch() {
        guard self.fieldsAlreadySet == false else { return }
        self.fieldsAlreadySet = true
        self.descriptionTransition?.text = self.currentStretch.title
        self.setupTransitionVideoPlayer()
        self.ringTimerAnimation()
    }
    
    func setupTransitionVideoPlayer() {
        self.setupVideoController()
        self.startTransionVideo()
    }
    
    func setupVideoController(){
        guard self.videoTransitionView != nil else { return }
        self.videoTransitionView.addSubview(stretchVideoController.view)
        stretchVideoController.showsPlaybackControls = false
        stretchVideoController.view.backgroundColor = .clear
        stretchVideoController.videoGravity = .resizeAspectFill
        stretchVideoController.view.frame = self.videoTransitionView.bounds
        stretchVideoController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func startTransionVideo() {
        let videoName = self.currentStretch.videoName

        print("[TransitionViewController] CurrentStretch: \(self.currentStretch.title)")
        print("Transition video: \(videoName)")
        let videoPath = Bundle.main.path(forResource: videoName, ofType: "mp4")
        let videoUrl = URL(fileURLWithPath: videoPath!)
        stretchVideoController.player = AVPlayer(url: videoUrl)
        
        stretchVideoController.player?.playImmediately(atRate: 2.5)
    }
    
    override func viewDidLoad() {
        self.counterLabel = self.view.subviews.first {
            view in type(of: view) == UILabel.self
        } as? UILabel
        self.counterLabel.text = "\(self.viewModel.transitionLenghtInSeconds)"
        self.viewModel.start()
        self.viewModel.onPublished = self.onPublished
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setFieldsForCurrentStretch()
    }
    
    override func viewDidLayoutSubviews() {
        self.startTimerAnimation()
        
        self.circlePath     = UIBezierPath.init(arcCenter: timerLabel.center, radius: timerLabel.frame.width, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulsatingLayer.path = UIBezierPath(arcCenter: .zero, radius: timerLabel.frame.width, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
        trackShape.path     = circlePath.cgPath
        shape.path          = circlePath.cgPath
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        onDismiss?()
    }
    
    // MARK: - Ring Animation
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor, radius: CGFloat) -> CAShapeLayer {
        
        let layer = CAShapeLayer()
        let circularPath  = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        layer.path        = circularPath.cgPath
        layer.strokeColor = self.transitionColor.pulse.cgColor
        layer.lineWidth   = 16
        layer.fillColor   = fillColor.cgColor
        layer.lineCap     = .round
        layer.position    = timerLabel.center
        return layer
    }
    
    func startTimerAnimation() {
        
        if !self.ringAlreadySetuped {
            self.ringAlreadySetuped = true
        } else {
            return
        }
        
        let label = self.view.subviews.first { view in
            return type(of: view) == UILabel.self
        }
        
        guard let label = label else { return }
         
        self.circlePath = UIBezierPath.init(arcCenter: label.center, radius: label.frame.width, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulsatingLayer = createCircleShapeLayer(strokeColor: .green, fillColor: UIColor.clear, radius: label.frame.width)
        view.layer.addSublayer(pulsatingLayer)
        
        //animatePulsatingLayer()
                    
        view.addShadow(layer: trackShape, path: self.circlePath, color: transitionColor.shadowColor)
        
        trackShape.path         = circlePath.cgPath
        trackShape.fillColor    = UIColor.clear.cgColor
        trackShape.lineWidth    = 15
        trackShape.strokeColor  = transitionColor.trackColor.cgColor
        view.layer.addSublayer(trackShape)

        shape.path         = circlePath.cgPath
        shape.lineWidth    = 15
        shape.strokeColor  = transitionColor.shapeColor.cgColor
//        shape.strokeColor  = circleAttributed.shapeColor.cgColor
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
        startAnimate.duration = CFTimeInterval(self.viewModel.transitionLenghtInSeconds)
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
}
