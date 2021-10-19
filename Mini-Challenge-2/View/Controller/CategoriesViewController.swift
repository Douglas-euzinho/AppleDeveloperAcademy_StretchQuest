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

protocol CategoriesDelegate: AnyObject {
    func onSelected(category: TagCategory) -> Void
}

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var strengthCategory: UIView!
    
    @IBOutlet weak var postureCategory: UIView!
    
    @IBOutlet weak var flexibilityCategory: UIView!
    
    weak var delegate: CategoriesDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupGestures()
        
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
        
        self.delegate.onSelected(
            category: TagCategory(rawValue: sender.tag) ?? .posture)
    }
    
    private func createTapGesture() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(didTappedCategory))
    }

}
