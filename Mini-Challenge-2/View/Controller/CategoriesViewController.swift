//
//  CategoriesViewController.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 13/10/21.
//

import UIKit
import SwiftUI

enum TagCategory: Int {
    case strenght, posture, flexibility
}

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var strengthCategory: UIView!
    
    @IBOutlet weak var postureCategory: UIView!
    
    @IBOutlet weak var flexibilityCategory: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupGestures() {
        strengthCategory.tag = TagCategory.strenght.rawValue
        postureCategory.tag = TagCategory.posture.rawValue
        flexibilityCategory.tag = TagCategory.flexibility.rawValue
        
        strengthCategory.addGestureRecognizer(createTapGesture())
        postureCategory.addGestureRecognizer(createTapGesture())
        flexibilityCategory.addGestureRecognizer(createTapGesture())
    }
    
    @objc private func didTappedCategory(_ sender: UITapGestureRecognizer?) {
        guard let sender = sender?.view else { return }
        
        switch sender.tag {
        case TagCategory.strenght.rawValue:
            // TODO: Redirect to stretch strength
            print("Strength")
        case TagCategory.posture.rawValue:
            // TODO: Redirect to stretch posture
            print("Posture")
        case TagCategory.flexibility.rawValue:
            // TODO: Redirect to stretch flexibility
            print("Flexibility")
        default:
            print("No exists.")
        }
    }
    
    private func createTapGesture() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(didTappedCategory))
    }

}
