//
//  ProfileViewController.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 14/10/21.
//

import UIKit
import Core
import SwiftUI

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var cameraButton: UICircle!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var strengthProgress: UIStackView!
    
    @IBOutlet weak var strengthLabel: UILabel!
    
    @IBOutlet weak var postureProgress: UIStackView!
    
    @IBOutlet weak var postureLabel: UILabel!
    
    @IBOutlet weak var flexibilityProgress: UIStackView!
    
    @IBOutlet weak var flexibilityLabel: UILabel!

    var viewModel: ProfileViewModel!
    
    let maskLayer: CAShapeLayer = {
        let circle = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        let overlay = CAShapeLayer()
        overlay.path = circle.cgPath
        overlay.fillColor = UIColor.gray.cgColor
        
        return overlay
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.didPublish = self.onViewModelDidPublish
       
        // Do any additional setup after loading the view.
        nameLabel.isUserInteractionEnabled = true
        
        setupGesturesCameraButton()
        setupGesturesName()
        
        fetchUser()
        
        configureImageProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.requestCurrentUserAttributes()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        maskLayer.path = UIBezierPath(ovalIn: imageProfile.bounds).cgPath
    }
    
    func onViewModelDidPublish() {
        self.set(
            progress: self.viewModel.userAttributes.flexibility,
            to: self.flexibilityProgress)
        
        self.set(
            progress: self.viewModel.userAttributes.posture,
            to: self.postureProgress)
        
        self.set(
            progress: self.viewModel.userAttributes.strength,
            to: self.strengthProgress)
        
        self.flexibilityLabel.text = "Level \(self.viewModel.userAttributes.flexibility)"
        self.postureLabel.text = "Level \(self.viewModel.userAttributes.posture)"
        self.strengthLabel.text = "Level \(self.viewModel.userAttributes.strength)"
    }
    
    func set(progress: Int, to stackViewProgressIndicator: UIStackView){
        
        let progressBlocks = stackViewProgressIndicator.arrangedSubviews.prefix(progress)
        
        progressBlocks.forEach { view in
            view.backgroundColor = .red
        }
    }
    
    private func configureImageProfile() {
        if imageProfile.image == nil {
            imageProfile.layer.addSublayer(maskLayer)
        } else {
            imageProfile.layer.mask = maskLayer
        }
    }
    
    private func setupGesturesCameraButton() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraButton))
        
        cameraButton.addGestureRecognizer(tap)
    }
    
    private func setupGesturesName() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapName))
        
        nameLabel.addGestureRecognizer(tap)
    }
    
    @objc private func didTapCameraButton(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Choose source type", message: nil, preferredStyle: .alert)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { handler in
            self.openCamera(source: .camera)
        }
        
        let library = UIAlertAction(title: "Library", style: .default) { handler in
            self.openCamera(source: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { handler in
            self.dismiss(animated: true)
        }
        
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapName(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Write your name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter your name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert in
            let nameTextField = alertController.textFields![0] as UITextField
            
            DatabaseUser.instance.saveNameInCore(nameTextField.text!)
            
            self.nameLabel.text = nameTextField.text!
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func savePhoto() {
        guard let image = imageProfile.image else { return }
        
        if let jpg = image.jpegData(compressionQuality: 0.5) {
            DatabaseUser.instance.saveImageInCore(jpg)
        }
    }
    
    func fetchUser() {
        let user = DatabaseUser.instance.user
        
        if let imageProfile = user?.imageProfile {
            self.imageProfile.image = UIImage(data: imageProfile)
        }
        
        if let name = user?.name {
            self.nameLabel.text = name
        }
    }

}

//EXTENSÃO DA CLASSE QUE VAI TER A CAMERA(A DE PERFIL)
//PROVAVELMENTE VAI TER Q HERDAR O UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        savePhoto()
    }
    
    func openCamera(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        
        present(picker, animated: true)
    }
    
}
