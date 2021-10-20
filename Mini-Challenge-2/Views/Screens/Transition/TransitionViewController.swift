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
    
    override func viewDidDisappear(_ animated: Bool) {
        onDismiss?()
    }
}
