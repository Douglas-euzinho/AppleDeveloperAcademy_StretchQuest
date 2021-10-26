//
//  RewardViewController.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 18/10/21.
//

import UIKit

protocol RewardDelegate: AnyObject {
    func exitToCategoriesScreen() -> Void
    func gotoNextSession() -> Void
}

class RewardViewController: UIViewController {
    
    @IBOutlet weak var animation: UIImageView!
    
    @IBOutlet weak var congratulations: UILabel!
    
    @IBOutlet weak var punctuation: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var leaveButton: UIButton!
    
    weak var delegate: RewardDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.congratulations.text = "Session completed!"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        adjustsFontSizeButton(continueButton)
        adjustsFontSizeButton(leaveButton)
    }
    
    private func adjustsFontSizeButton(_ button: UIButton) {
        let font = button.titleLabel!.font!
        
        button.titleLabel!.font = font.withSize(button.frame.height / 1.87)
    }
    
    @IBAction func didTappedContinue(_ sender: UIButton) {
        self.dismiss(animated: true)
        Haptics.share.vibrateSuccess()
        self.delegate.gotoNextSession()
    }
    
    @IBAction func didTappedLeave(_ sender: Any) {
        Haptics.share.vibrateError()
        self.delegate.exitToCategoriesScreen()
    }
    
}
