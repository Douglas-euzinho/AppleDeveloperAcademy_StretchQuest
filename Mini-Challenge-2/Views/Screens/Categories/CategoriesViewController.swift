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
    
    //checar se foi autenticado ou não no game center
    var gameCenterEnabled: Bool = false //Coisa do gameCenter
    
    //variáveis para checar a quantidade de sessões feitas para cada tipo
    var sessionStrengthDid: Int = 0 //Coisa do gameCenter
    var sessionFlexibilityDid: Int = 0 //Coisa do gameCenter
    var sessionPostureDid: Int = 0 //Coisa do gameCenter
    
    //variáveis para checar se é a primeira vez ou não iniciando uma sessão do tipo do alongamento específico
    var firstStrengthSession: Bool = false //Coisa do gameCenter
    var firstPostureSession: Bool = false //Coisa do gameCenter
    var firstFlexibilitySession: Bool = false //Coisa do gameCenter
    
    //variáveis para checar se é a primeira vez ou não iniciando o primeiro alongamento do tipo de alongamento específico
    var firstStrengthStretch: Bool = false //Coisa do gameCenter
    var firstPostureStretch: Bool = false //Coisa do gameCenter
    var firstFlexibilityStretch: Bool = false //Coisa do gameCenter
    
    //COISA DA NOTIFICAÇÃO
    let date = Date()
    let calendar = Calendar.current
    var day: Int = 0
    
    //compartilhamento de variáveis e funções em outras classes. Singleton
    static let sharedGC = CategoriesViewController() //Coisa do gameCenter
    
    
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
    
    func showOnBoarding() {
        
        let adapter = OnboardDismissDelegate()
    
        let contentView = ContentView(delegate: adapter)
        
        let viewController = UIHostingController(rootView: contentView)
        
        adapter.onDismiss = {
            viewController.dismiss(animated: true)
        }
        
        viewController.modalPresentationStyle = .fullScreen
        
        self.present(viewController, animated: true)
    }
    
    //Coisa do gameCenter
    @IBAction func leader(_ sender: Any) {
        self.transitionToLeadersGameCenter()
    }
    //Coisa do gameCenter
    @IBAction func achievements(_ sender: Any) {
        self.transitionToAchievementsGameCenter()
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
            if self.firstStrengthSession == false{
                //print("força entrou")
                self.unlockAchievementSpecified(nameAchievement: "FirstStrengthSessionStarted")
                self.firstStrengthSession = true
            }else{
                //print("força n entrou")
            }
        case postureCategory.tag:
            if self.firstPostureSession == false{
                //print("postura entrou")
                self.unlockAchievementSpecified(nameAchievement: "FirstPostureSessionStarted")
                self.firstPostureSession = true
            }else{
                //print("postura n entrou")
            }
        case flexibilityCategory.tag:
            if self.firstFlexibilitySession == false{
                //print("flexibilidade entrou")
                self.unlockAchievementSpecified(nameAchievement: "FirstFlexibilitySessionStarted")
                self.firstFlexibilitySession = true
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
