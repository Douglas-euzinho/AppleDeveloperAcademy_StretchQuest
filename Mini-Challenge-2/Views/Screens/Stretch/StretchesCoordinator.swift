//
//  StretchesCoordinator.swift
//  Mini-Challenge-2
//
//  Created by Iorgers Almeida on 25/10/21.
//

import UIKit
import Core

class StretchesCoordinator: Coordinator {
    
    let sessionsRepository = CoreDataStrechesSessionsRepository()//FakeStretchesSessionRepository()
    var navigationController: UIViewController
    var stretchViewController: StretchViewController
    var rootController: UITabBarController

    init(
        _ navigationController: UIViewController,
        _ rootController: UITabBarController,
        stretchType: StretchType
    ) {
        self.navigationController = navigationController
        self.rootController = rootController
        
        let story = UIStoryboard(name: "Stretch", bundle:nil)
        let stretchViewController =
            story.instantiateViewController(withIdentifier: "StretchViewController") as! StretchViewController
        
        // Inicializa a view model passando a categoria
        let viewModel = StretchesViewModel(
            stretchType,
            sessionsRepository
        )
        
        stretchViewController.viewModel = viewModel
        stretchViewController.exitToCategories = {
            MainCoordinator.stretchCoordinator = nil
            navigationController.dismiss(animated: true, completion: nil)
        }

        self.stretchViewController = stretchViewController
    }
    
    override func start() {
        
        stretchViewController.exitAndGotoNextSession = {
            self.gotoNextSession()
            
            //self.navigationController.dismiss(animated: true){
                //self.gotoNextSession()
            //}
        }
        
        self.stretchViewController.modalPresentationStyle = .fullScreen
        
        self.navigationController.present(self.stretchViewController, animated: true)
        
    }
    
    func startStretchSessionFromOnBoarding() {
        
        stretchViewController.exitAndGotoNextSession = {
            self.gotoNextSession()
            
            //self.navigationController.dismiss(animated: true){
                //self.gotoNextSession()
            //}
        }
        
        self.stretchViewController.modalPresentationStyle = .fullScreen
        
        self.navigationController.present(self.stretchViewController, animated: false)
    }
                                              
    func gotoNextSession() {
    
        let getNextSessionType = GetNextSessionType(sessionsRepository)
        
        let type = getNextSessionType.execute()
        
        let nextStretchViewModel = StretchesViewModel(
            type,
            self.sessionsRepository
        )
        
        self.stretchViewController.viewModel = nextStretchViewModel
    }
    
}
