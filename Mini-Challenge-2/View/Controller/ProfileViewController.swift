//
//  ProfileViewController.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 14/10/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var cameraButton: Bola!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupGestures()
        
        imageProfile.clipsToBounds = true
        imageProfile.layer.cornerRadius = imageProfile.frame.size.width / 2
        imageProfile.layer.borderWidth = 5.0
        imageProfile.layer.borderColor = cameraButton.fillColor.cgColor
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
