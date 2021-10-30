//
//  CategoriesViewController.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 13/10/21.
//

import UIKit
import SwiftUI
import Core


protocol CategoriesDelegate: AnyObject {
    func onSelected(category: StretchType) -> Void
}

class CategoriesViewController: UIViewController {
    
    //COISA DA NOTIFICAÇÃO
    let date = Date()
    let calendar = Calendar.current
    var day: Int = 0
    
    static let sharedGC = CategoriesViewController()
    
    @IBOutlet weak var onboardingButton: UIButton!
    
    @IBOutlet weak var strengthCategory: UIView!
    
    @IBOutlet weak var postureCategory: UIView!
    
    @IBOutlet weak var flexibilityCategory: UIView!
    
    var delegate: CategoriesDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupGestures()
        
//        self.authenticateUser()//Coisa do gameCenter
        self.day = calendar.component(.day, from: date) //NOTIFICAÇÃO
        
    }
    
    @IBAction func showOnBoarding() {
        
        let adapter = OnboardDismissDelegate()
    
        let contentView = ContentView(delegate: adapter)
        
        let viewController = UIHostingController(rootView: contentView)
        
        adapter.onDismiss = {
            viewController.dismiss(animated: true)
        }
        
        viewController.modalPresentationStyle = .fullScreen
        
        self.present(viewController, animated: true)
    }
    
    private func setupGestures() {
        strengthCategory.tag    = StretchType.strength.rawValue
        postureCategory.tag     = StretchType.posture.rawValue
        flexibilityCategory.tag = StretchType.flexibility.rawValue
        
        strengthCategory.addGestureRecognizer(createTapGesture())
        postureCategory.addGestureRecognizer(createTapGesture())
        flexibilityCategory.addGestureRecognizer(createTapGesture())
    }
    
    @objc private func didTappedCategory(_ sender: UITapGestureRecognizer?) {
        guard let sender = sender?.view else { return }
        
        Haptics.share.vibrateSuccess()
        
        self.delegate.onSelected(
            category: StretchType(rawValue: sender.tag) ?? .posture)
        
        
        //Validado e rodando - ✅
        //print("sender: \(sender.tag)")
        switch sender.tag {
        case strengthCategory.tag:
            if ProfileViewController.sharedPVC.firstStrengthSession == false{
                //print("força entrou")
                ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "FirstStrengthSessionStarted")
                ProfileViewController.sharedPVC.firstStrengthSession = true
            }else{
                //print("força n entrou")
            }
        case postureCategory.tag:
            if ProfileViewController.sharedPVC.firstPostureSession == false{
                //print("postura entrou")
                ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "FirstPostureSessionStarted")
                ProfileViewController.sharedPVC.firstPostureSession = true
            }else{
                //print("postura n entrou")
            }
        case flexibilityCategory.tag:
            if ProfileViewController.sharedPVC.firstFlexibilitySession == false{
                //print("flexibilidade entrou")
                ProfileViewController.sharedPVC.unlockAchievementSpecified(nameAchievement: "FirstFlexibilitySessionStarted")
                ProfileViewController.sharedPVC.firstFlexibilitySession = true
            }else{
                //print("flexibilidade n entrou")
            }
        default:
            print("se entrou ak é pq deu caquinha")
        }
        

    }
    
    private func createTapGesture() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(didTappedCategory))
    }
}
