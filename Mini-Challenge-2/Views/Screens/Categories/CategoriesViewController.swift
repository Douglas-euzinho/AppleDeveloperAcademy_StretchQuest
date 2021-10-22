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
    
    
    @IBOutlet weak var strengthCategory: UIView!
    
    @IBOutlet weak var postureCategory: UIView!
    
    @IBOutlet weak var flexibilityCategory: UIView!
    
    var delegate: CategoriesDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupGestures()
        
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
        
        self.delegate.onSelected(
            category: StretchType(rawValue: sender.tag) ?? .posture)
    }
    
    private func createTapGesture() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(didTappedCategory))
    }
    
}
