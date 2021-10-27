//
//  ProfileViewController.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 14/10/21.
//

import UIKit
import Core

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var cameraButton: UICircle!
    
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
        
        let progressBlocks = stackViewProgressIndicator
            .arrangedSubviews.prefix(progress)
        
        let imagem = UIImage(named: "ok2")
        
        progressBlocks.forEach({ view in
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            imageView.image = imagem
                        
            view.addSubview(imageView)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.didPublish = self.onViewModelDidPublish
       
        
        // Do any additional setup after loading the view.
        setupGestures()
        
        configureImageProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.requestCurrentUserAttributes()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        maskLayer.path = UIBezierPath(ovalIn: imageProfile.bounds).cgPath
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
        let alert = UIAlertController(title: "Choose source type", message: nil, preferredStyle: .alert)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { handler in
            self.openCamera(source: .camera)
        }
        
        let library = UIAlertAction(title: "Library", style: .default) { handler in
            self.openCamera(source: .photoLibrary)
        }
        
        alert.addAction(camera)
        alert.addAction(library)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func openCamera(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        
        present(picker, animated: true)
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
