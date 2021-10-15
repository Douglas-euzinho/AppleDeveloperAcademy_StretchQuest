//
//  Camera.swift
//  Mini-Challenge-2
//
//  Created by Douglas Figueirôa on 15/10/21.
//

import Foundation
import UIKit

//EXTENSÃO DA CLASSE QUE VAI TER A CAMERA(A DE PERFIL)
//PROVAVELMENTE VAI TER Q HERDAR O UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    /*
     1-
     TER UMA VARIÁVEL DO TIPO UIImageView
     
     2-
     COLOCAR DENTRO DA FUNÇÃO DO BOTÃO DA CAMERA:
     "
     let picker = UIImagePickerController()
     picker.sourceType = .camera
     picker.delegate = self
     present(picker, animated: true)
     "
     */
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("entrou camera?")
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            return
        }
        
        imageView.image = image
    }
    
}
