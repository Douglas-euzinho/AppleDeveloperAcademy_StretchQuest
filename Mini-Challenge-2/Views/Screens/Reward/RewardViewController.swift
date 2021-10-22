//
//  RewardViewController.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 18/10/21.
//

import UIKit

class RewardViewController: UIViewController {
    
    @IBOutlet weak var animation: UIImageView!
    
    @IBOutlet weak var punctuation: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var leaveButton: UIButton!
    
    var rewardViewModel: RewardViewModel! = RewardViewModel(category: .posture)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        adjustsFontSizeButton(continueButton)
        adjustsFontSizeButton(leaveButton)
    }
    
    private func adjustsFontSizeButton(_ button: UIButton) {
        let font = button.titleLabel!.font!
        
        button.titleLabel!.font = font.withSize(button.frame.height / 2.5)
    }
    
    @IBAction func didTappedContinue(_ sender: UIButton) {
    }
    
    @IBAction func didTappedLeave(_ sender: Any) {
    }
    
}
