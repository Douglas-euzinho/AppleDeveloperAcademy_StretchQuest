//
//  TransitionViewController.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 18/10/21.
//

import UIKit

//protocol TransitionDelegate: AnyObject {
//    func viewDidDisappear()
//}

typealias OnDismiss = () -> ()

class TransitionViewController: UIViewController {

    var onDismiss: OnDismiss?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.dismiss(animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        onDismiss?()
    }
}
