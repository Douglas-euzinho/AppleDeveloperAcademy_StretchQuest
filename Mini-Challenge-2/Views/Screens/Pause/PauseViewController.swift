//
//  PauseViewController.swift
//  Mini-Challenge-2
//
//  Created by Daniel Gomes Ribeiro on 16/10/21.
//

import UIKit

protocol PauseDelegate: AnyObject {
    func viewDidDisappear()
}

class PauseViewController: UIViewController {
    
    weak var delegate: PauseDelegate?

    override func viewDidDisappear(_ animated: Bool) {
        delegate?.viewDidDisappear()
    }
}
