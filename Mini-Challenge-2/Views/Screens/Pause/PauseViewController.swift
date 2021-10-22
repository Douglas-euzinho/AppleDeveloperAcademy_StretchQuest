//
//  PauseViewController.swift
//  Mini-Challenge-2
//
//  Created by Daniel Gomes Ribeiro on 16/10/21.
//

import UIKit

protocol PauseDelegate: AnyObject {
    func onPauseScreenDismiss()
    func exitToCategoriesScreen()
}

class PauseViewController: UIViewController {
    
    weak var delegate: PauseDelegate?
    
    var exitToCategories: Bool = false
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.exitToCategories {
            delegate?.exitToCategoriesScreen()
        }else {
            delegate?.onPauseScreenDismiss()
        }
    }
    
    // Botão de sair
    @IBAction func didTappedLeave(_ sender: Any) {
        // Flag para voltar para a Tela de categorias!!!
        self.exitToCategories = true
        dismiss(animated: true, completion: nil)
    }
    
    // Botão de voltar ao alongagmento
    @IBAction func didTappedKeep(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
