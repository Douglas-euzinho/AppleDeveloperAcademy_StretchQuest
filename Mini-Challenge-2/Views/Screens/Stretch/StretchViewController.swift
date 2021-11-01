//
//  StretchViewController.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 14/10/21.
//

import UIKit
import Core
import AVKit

class StretchViewController: UIViewController {

   
    // MARK: Properties
    @IBOutlet weak var descriptionStretch: UILabel!
    @IBOutlet weak var timerElipse: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var videoView: UIView!
    
    public let stretchVideoController = AVPlayerViewController()
    
    var firstStretch: Bool = true
    var pausedStretch: Bool = false

    var viewModel: StretchesViewModel! {
        didSet {
            self.viewModel.publishStretch = self.stretchDidChange
            self.viewModel.publishCountdown = self.counterDidChange
            self.viewModel.publishShowRewardsScreen = self.showRewardsScreen
            self.pulsatingLayer.removeFromSuperlayer()
            self.trackShape.removeFromSuperlayer()
            self.setupRingAnimation()
            self.setupVideoView()
            self.setupStretchVideo()
        }
    }
    
    //Retorna o attributed de acordo com a categoria
    var circleAttributed: RingColorAttributes {
        UIColor.getColorBy(category: viewModel.category)
    }
    
    var exitToCategories: (() -> Void)?
    var exitAndGotoNextSession: () -> () = {}
    
    var timer: Timer?
    
    //Ring properties
    var pulsatingLayer = CAShapeLayer()
    let shape          = CAShapeLayer()
    let trackShape     = CAShapeLayer()
    var circlePath     = UIBezierPath()
    
    func showTransitionBetweenStretches() {
        if self.firstStretch == true{
            
        }else{
            Sounds.sharedS.playSoundStretchDid()
        }
        let transitionStoryboard = UIStoryboard(name: "Transition", bundle: nil)
        let transitionViewController = transitionStoryboard.instantiateViewController(withIdentifier: "TransitionViewController") as! TransitionViewController
        
        transitionViewController.currentStretch = self.viewModel.currentStretch
    
//        transitionViewController.modalTransitionStyle = .crossDissolve
        
        self.applyBlur()
        
        self.present(transitionViewController, animated: false)
        
        self.shape.isHidden = true
        
        transitionViewController.onDismiss = {
            self.removeBlur()
            
            self.firstStretch = false
            
            self.beginStretch()
            self.stretchVideoController.player?.play()
            self.viewModel.startCountdownTimer()
        }
    }
    
    func beginStretch() {
        self.shape.isHidden = false
        self.ringTimerAnimation()
        self.stretchVideoController.player?.play()
    }
    
    func stretchDidChange() {
        self.view.layer.removeAnimation(forKey: "transform.scale")
        self.pulsatingLayer.removeFromSuperlayer()
        self.trackShape.removeFromSuperlayer()
        
        self.setupRingAnimation()
        self.changeStretchVideo()
        self.descriptionStretch.text = "\(self.viewModel.currentStretch.title)"
        
        if self.viewModel.mustShowTransition {
            self.showTransitionBetweenStretches()
        } else {
            self.beginStretch()
        }
        
        print("current stretch: \(self.viewModel.currentStretch)")
    }
    
    func counterDidChange(counter: Int) {
        self.timerLabel.text = "\(counter)"
    }
    
    func showRewardsScreen() {
        self.firstStretch = true
        let rewardsStoryboard = UIStoryboard(name: "Reward", bundle: nil)
        
        let rewardsViewController =
            rewardsStoryboard.instantiateViewController(
                withIdentifier: "RewardViewController") as! RewardViewController
        
        rewardsViewController.modalPresentationStyle = .fullScreen
        
        self.show(rewardsViewController, sender: nil)
        
        Sounds.sharedS.playSoundSessionStretchDid()
        switch(self.viewModel.category){
        case .flexibility:
            rewardsViewController.punctuation.text = "Flexibility +1"
            
            var x = ProfileViewController.sharedPVC.checkingIfUserIsAuthenticated()
            if x == true{
                ProfileViewController.sharedPVC.sessionFlexibilityDid += 1
                ProfileViewController.sharedPVC.callGameCenterFlexibility(ProfileViewController.sharedPVC.sessionFlexibilityDid)
                
                if ProfileViewController.sharedPVC.sessionFlexibilityDid == 1{
                    ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "Get1PointInFlexibility")
                }else if ProfileViewController.sharedPVC.sessionFlexibilityDid >= 5{
                    ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "Get1PointInFlexibility")
                    ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "Get5PointsInFlexibility")
                }
            }
            
        case .posture:
            rewardsViewController.punctuation.text = "Posture +1"
            
            var x = ProfileViewController.sharedPVC.checkingIfUserIsAuthenticated()
            if x == true{
                ProfileViewController.sharedPVC.sessionPostureDid += 1
                ProfileViewController.sharedPVC.callGameCenterPosture(ProfileViewController.sharedPVC.sessionPostureDid)
                
                if ProfileViewController.sharedPVC.sessionPostureDid == 1{
                    ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "Have1PointInPosture")
                }else if ProfileViewController.sharedPVC.sessionPostureDid >= 5{
                    ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "Have1PointInPosture")
                    ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "Have5PointsInPosture")
                }
            }
        case .strength:
            rewardsViewController.punctuation.text = "Strength +1"
            
            var x = ProfileViewController.sharedPVC.checkingIfUserIsAuthenticated()
            if x == true{
                ProfileViewController.sharedPVC.sessionStrengthDid += 1
                ProfileViewController.sharedPVC.callGameCenterStrength(ProfileViewController.sharedPVC.sessionStrengthDid)
                if ProfileViewController.sharedPVC.sessionStrengthDid == 1{
                    ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "Have1PointInStrength")
                }else if ProfileViewController.sharedPVC.sessionStrengthDid >= 5{
                    ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "Have1PointInStrength")
                    ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "Have5PointsInStrength")
                }
            }
            }
        
        rewardsViewController.delegate = self
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Validado e rodando - ✅
        //print("********TESTE \(self.viewModel.category ) FIM TESTE********")
        switch (self.viewModel.category) {
        case .strength:
            var x = ProfileViewController.sharedPVC.checkingIfUserIsAuthenticated()
            if x == true{
                if ProfileViewController.sharedPVC.firstStrengthStretch == false{
                    //print("força entrou")
                    ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "FirstStrengthStretch")
                    ProfileViewController.sharedPVC.firstStrengthStretch = true
                }else{
                    //print("força n entrou")
                }
            }
        case .posture:
            var x = ProfileViewController.sharedPVC.checkingIfUserIsAuthenticated()
            if x == true{
                if ProfileViewController.sharedPVC.firstPostureStretch == false{
                    //print("postura entrou")
                    ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "FirstPostureStretch")
                    ProfileViewController.sharedPVC.firstPostureStretch = true
                }else{
                    //print("postura n entrou")
                }
            }
        case .flexibility:
            var x = ProfileViewController.sharedPVC.checkingIfUserIsAuthenticated()
            if x == true{
                if ProfileViewController.sharedPVC.firstFlexibilityStretch == false{
                    //print("flexibilidade entrou")
                    ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "FirstFlexibilityStretch")
                    ProfileViewController.sharedPVC.firstFlexibilityStretch = true
                }else{
                    //print("flexibilidade n entrou")
                }
            }
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.circlePath     = UIBezierPath.init(arcCenter: timerLabel.center, radius: timerLabel.frame.width, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        pulsatingLayer.path = UIBezierPath(arcCenter: .zero, radius: timerLabel.frame.width, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
        trackShape.path     = circlePath.cgPath
        shape.path          = circlePath.cgPath
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.startSession()
    }
    
    func setupVideoView() {
        videoView.layer.cornerRadius = 20
        videoView.clipsToBounds = true
        videoView.backgroundColor = .clear
    }
    
    func setupStretchVideo(){
        videoView.addSubview(stretchVideoController.view)
        stretchVideoController.showsPlaybackControls = false
        stretchVideoController.view.backgroundColor = .clear
        stretchVideoController.videoGravity = .resizeAspectFill
        stretchVideoController.view.frame = videoView.bounds
        stretchVideoController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func changeStretchVideo() {
        let videoName = self.viewModel.currentStretch.videoName

        print("Video stretch name: \(videoName)")
        let videoPath = Bundle.main.path(forResource: videoName, ofType: "mp4")
        let videoUrl = URL(fileURLWithPath: videoPath!)
        stretchVideoController.player = AVPlayer(url: videoUrl)
    }
    
    func pauseStretchVideo() {
        stretchVideoController.player?.pause()
    }
    
    @IBAction func presentPauseViewController() {
        pauseStretchVideo()
        showPauseViewController()
    }
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor, radius: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath  = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        layer.path        = circularPath.cgPath
        layer.strokeColor = self.circleAttributed.pulse.cgColor
        layer.lineWidth   = 16
        layer.fillColor   = fillColor.cgColor
        layer.lineCap     = .round
        layer.position    = timerLabel.center
        return layer
    }
    
    func setupRingAnimation() {
        
        let label = self.view.subviews.first { view in
            return type(of: view) == UILabel.self
        }
        
        guard let label = label else { return }
        
        self.circlePath = UIBezierPath.init(arcCenter: label.center, radius: label.frame.width, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulsatingLayer = createCircleShapeLayer(strokeColor: .green, fillColor: UIColor.clear, radius: label.frame.width)
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
        startAnimate.duration = CFTimeInterval(self.viewModel.currentStretch.durationInSeconds)
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
    
    func showPauseViewController() {
        let story = UIStoryboard(name: "Pause", bundle: nil)
        let pauseViewController = story.instantiateViewController(withIdentifier: "PauseViewController") as! PauseViewController
        
        pauseViewController.onResumeHandler = {
            self.stretchVideoController.player?.play()
        }
        
        self.viewModel.pauseCountdownTime()
        pauseRingAnimation()
        pauseViewController.delegate = self

        self.applyBlur()
        
        self.pausedStretch = true
        
        self.present(pauseViewController, animated: true, completion: nil)
    }
}

extension StretchViewController: PauseDelegate {
    
    func onPauseScreenDismiss() {
        self.removeBlur()
        self.viewModel.resumeCountdownTimer()
        self.resumeRingAnimation()
        self.pausedStretch = false
    }
    
    func exitToCategoriesScreen() {
        print("[StretchViewController] exitToCategories()")
        self.exitToCategories?()
    }
}

extension StretchViewController: RewardDelegate {
    
    func gotoNextSession() {
        self.exitAndGotoNextSession()
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
