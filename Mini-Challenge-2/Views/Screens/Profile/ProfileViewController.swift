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
    
    @IBOutlet weak var cameraButton: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var gameCenterButton: UIImageView!
    
    @IBOutlet weak var strengthProgress: UIStackView!
    
    @IBOutlet weak var strengthLabel: UILabel!
    
    @IBOutlet weak var postureProgress: UIStackView!
    
    @IBOutlet weak var postureLabel: UILabel!
    
    @IBOutlet weak var flexibilityProgress: UIStackView!
    
    @IBOutlet weak var flexibilityLabel: UILabel!

    var viewModel: ProfileViewModel!
    
    var gameCenterEnabled: Bool = false
    
    //variáveis para checar a quantidade de sessões feitas para cada tipo
    var sessionStrengthDid: Int = 0 //Coisa do gameCenter
    var sessionFlexibilityDid: Int = 0 //Coisa do gameCenter
    var sessionPostureDid: Int = 0 //Coisa do gameCenter
    
    //variáveis para checar se é a primeira vez ou não iniciando uma sessão do tipo do alongamento específico
    var firstStrengthSession: Bool = false //Coisa do gameCenter
    var firstPostureSession: Bool = false //Coisa do gameCenter
    var firstFlexibilitySession: Bool = false //Coisa do gameCenter
    
    //variáveis para checar se é a primeira vez ou não iniciando o primeiro alongamento do tipo de alongamento específico
    var firstStrengthStretch: Bool = false //Coisa do gameCenter
    var firstPostureStretch: Bool = false //Coisa do gameCenter
    var firstFlexibilityStretch: Bool = false //Coisa do gameCenter
    
    static let sharedPVC = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.didPublish = self.onViewModelDidPublish
       
        // Do any additional setup after loading the view.
        setupGesturesCameraButton()
        setupGesturesName()
        setupGesturesGameCenter()
        
        fetchUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.requestCurrentUserAttributes()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageProfile.layer.cornerRadius = imageProfile.frame.width / 2
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
        
        let imagem = UIImage(named: "ok2")
        
        progressBlocks.forEach({ view in
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            imageView.image = imagem
                        
            view.addSubview(imageView)
        })
    }
    
    private func setupGesturesCameraButton() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraButton))
        
        cameraButton.addGestureRecognizer(tap)
        cameraButton.isUserInteractionEnabled = true
    }
    
    private func setupGesturesName() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapName))
        
        nameLabel.addGestureRecognizer(tap)
        nameLabel.isUserInteractionEnabled = true
    }
    
    private func setupGesturesGameCenter() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapGameCenterButton))
        
        gameCenterButton.addGestureRecognizer(tap)
        gameCenterButton.isUserInteractionEnabled = true
    }
    
    // MARK: - Botão da camera
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
    
    // MARK: - Botão do nome
    @objc private func didTapName(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Write your name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter your name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert in
            let nameTextField = alertController.textFields![0] as UITextField
            
            if let text = nameTextField.text {
                guard !text.isEmpty else { return }
                
                DatabaseUser.instance.saveNameInCore(text)
                
                self.nameLabel.text = text
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Botão do gameCenter
    @objc private func didTapGameCenterButton(_ sender: UITapGestureRecognizer) {
        if self.gameCenterEnabled == false {
            self.authenticateUser()
        } else{
            self.transitionToGameCenterPage()
        }
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
