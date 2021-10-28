//
//  AppCoordinator.swift
//  Mini-Challenge-2
//
//  Created by Daniel Gomes Ribeiro on 04/10/21.
//

import UIKit
import SwiftUI
import Core

extension UIViewController {
    
    func embededIn() -> UINavigationController{
        UINavigationController(rootViewController: self)
    }
    
}

// MARK: - Protocolos e implementação base do Coordinator

typealias FinishHandler = (ManagedCoordinator) -> ()

/// ViewCoordinator é a escolha "padrão" ao implementar um coordinator
typealias ViewCoordinator = ManagedCoordinator & CoordinatorManager

protocol BaseCoordinator: AnyObject {
    func start()
}

/// Um coordinator gerenciado, é um coordinator que precisa se manter na memória depois de ter
/// concluído seu objetivo primário (configurar e apresentar uma viewController).
protocol ManagedCoordinator: BaseCoordinator {
    var parent: CoordinatorManager? { get set }
    func finish() -> Void
}

/// Implementação padrão do método `finish()`
/// remove o coordinator do seu pai
extension ManagedCoordinator {
    func finish() {
        self.parent?.removeChild(self)
    }
}

/*
 Devido ao ARC, é necessário manter uma referência a um coordinator
 caso o mesmo precise ser utlizado por outro objeto.
 Um exemplo disso é o MainCoordinator, usado como "delegate" da view controller
 de categorias. Caso esse objeto não exista mais na memória, a propriedade delegate
 da do MainCoordinator será nil, causando um `crash` no app. Por isso, o MainCoordinator
 precisar ser *gerenciado* pelo seu coordinator pai, mantendo assim, pelo menos uma
 referência para o mesmo.
 */

/// CoordinatorManager é um coordinator que gerencia outros coordinators, mantêndo-os
/// na memória até que o método "finish()" seja chamado.
class CoordinatorManager: BaseCoordinator {
    
    var children = [ManagedCoordinator]()
    
    public func addChild(_ coordinator: ManagedCoordinator){
        coordinator.parent = self
        self.children.append(coordinator)
    }
    
    public func removeChild(_ coordinator: ManagedCoordinator){
        self.children = children.filter({ $0 !== coordinator })
    }
    
    func start() {
        preconditionFailure("start() must be overriden")
    }
    
}

class Coordinator: ViewCoordinator {
    var parent: CoordinatorManager?
    
    override init() {
        print("[Coordinator] alocado!")
        super.init()
    }
    
    deinit {
        print("[Coordinator] desalocado!")
    }
}

// MARK: - Implementações de Coordinators

class AppCoordinator: Coordinator {

    var window: UIWindow
    
    var didShowUserOnboard = UserDefaults.standard.bool(forKey: "alreadyEntry")
    
    init(
        window: UIWindow
    ) {
        self.window = window
    }

    override func start() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start()

        
        if !didShowUserOnboard {
//            mainCoordinator.start()
            self.window.rootViewController = mainCoordinator.rootViewController
        } else {
            let coordinator = OnboardingCoordinator()
            addChild(coordinator)
            
            coordinator.finishHandler = {
                self.removeChild(coordinator)
                self.window.rootViewController = mainCoordinator.rootViewController
                mainCoordinator.onSelecteOnBoarding(category: .posture)
            }
            
            coordinator.start()
            self.window.rootViewController = coordinator.rootViewController
            
            UserDefaults.standard.set(true, forKey: "alreadyEntry")
        }
    
        self.window.makeKeyAndVisible()
        
    }

}

class MainCoordinator: Coordinator, CategoriesDelegate {
    
    var rootViewController: UIViewController {
        self.tabController
    }
    
    public let tabController: UITabBarController
    
    override init() {
        self.tabController = UITabBarController()
    }

    override func start() {
        
        let story = UIStoryboard(name: "Categories", bundle: nil)
        
        let categoriesViewController = story.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        categoriesViewController.delegate = self
        
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        
        let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        profileViewController.viewModel = ProfileViewModel(CoreDataStrechesSessionsRepository())

        
        self.tabController.tabBar.layer.shadowOffset  = CGSize(width: 0, height: 0)
        self.tabController.tabBar.layer.shadowRadius  = 10
        self.tabController.tabBar.layer.shadowColor   = UIColor(red: 0/255, green: 128/255, blue: 115/255, alpha: 1).cgColor
        self.tabController.tabBar.layer.shadowOpacity = 0.1
        self.tabController.tabBar.backgroundColor     = .white
        self.tabController.tabBar.tintColor           = UIColor(red: 71/255, green: 204/255, blue: 193/255, alpha: 1)
        
        self.tabController.setViewControllers([
            categoriesViewController,
            profileViewController
        ], animated: false)
    }
    
    func onSelected(category: StretchType) { // Implementa o delegate
        
        print(category)
        
        let coordinator = StretchesCoordinator(
            (tabController.viewControllers!.first!), tabController,
            stretchType: category)
        
        coordinator.start()
        self.finish()
    }
    
    func onSelecteOnBoarding(category: StretchType) {
        
        let coordinator = StretchesCoordinator(
            (tabController.viewControllers!.first!), tabController,
            stretchType: category)
        
        coordinator.startStretchSessionFromOnBoarding()
        self.finish()
    }
}

class OnboardingCoordinator: Coordinator {

    var finishHandler: () -> () = {}
    
    var rootViewController: UIViewController {
        self.navigationController
    }
    
    var navigationController: UINavigationController

    override init() {
        self.navigationController = UINavigationController()
    }

    override func start() {
        
        let adapter = OnboardDismissDelegate()
        
        adapter.onDismiss = {
            self.finish()
        }
        
        let contentView = ContentView(delegate: adapter)
        
        let onBoarding = UIHostingController(rootView: contentView)
        self.navigationController.setViewControllers([onBoarding], animated: false)
    }
    
    func finish(){
        self.finishHandler()
    }
    
}
