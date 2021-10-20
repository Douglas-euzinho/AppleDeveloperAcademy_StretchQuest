//
//  ProfileViewController.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 14/10/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var cameraButton: Circle!
    
    let maskLayer: CAShapeLayer = {
        let circle = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        let overlay = CAShapeLayer()
        overlay.path = circle.cgPath
        overlay.fillColor = UIColor.gray.cgColor
        
        return overlay
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupGestures()
        
        configureImageProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        maskLayer.path = UIBezierPath(ovalIn: imageProfile.bounds).cgPath
        print(imageProfile.bounds)
    }
    
    private func configureImageProfile() {
        if imageProfile.image == nil {
            imageProfile.layer.addSublayer(maskLayer)
        } else {
            imageProfile.layer.mask = maskLayer
        }
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraButton))
        
        cameraButton.addGestureRecognizer(tap)
    }
    
    @objc private func didTapCameraButton(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let alert = UIAlertController(title: "Choose source type", message: nil, preferredStyle: .alert)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { handler in
            picker.sourceType = .camera
            
            self.present(picker, animated: true)
        }
        
        let library = UIAlertAction(title: "Library", style: .default) { handler in
            picker.sourceType = .photoLibrary
            
            self.present(picker, animated: true)
        }
        
        alert.addAction(camera)
        alert.addAction(library)
        
        present(alert, animated: true, completion: nil)
    }

}

//EXTENSÃO DA CLASSE QUE VAI TER A CAMERA(A DE PERFIL)
//PROVAVELMENTE VAI TER Q HERDAR O UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        if imageProfile.layer.mask == nil {
            imageProfile.layer.mask = maskLayer
        }
        
        imageProfile.image = image
    }
    
}
