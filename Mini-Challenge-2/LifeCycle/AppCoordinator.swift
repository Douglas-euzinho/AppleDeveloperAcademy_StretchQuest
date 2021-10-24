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

    var rootViewController: UIViewController
//    {
//        (self.children.first! as! MainCoordinator).rootViewController
//    }
    
    var didShowUserOnboard = UserDefaults.standard.bool(forKey: "alreadyEntry")
    
    override init() {
        let coordinator = MainCoordinator()
        
        coordinator.start()
        
        self.rootViewController = coordinator.rootViewController
        
        super.init()
        self.addChild(coordinator)
        
    }

    override func start() {
        if didShowUserOnboard {
            self.children.first!.start()
       } else {
           let coordinator = OnboardingCoordinator()
           addChild(coordinator)
           coordinator.start()
        }
        //self.navigationController.setNavigationBarHidden(true, animated: true)
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
        let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController")
        
        self.tabController.setViewControllers([
            categoriesViewController,
            profileViewController
        ], animated: false)
        
        
//        self.navigationController.setViewControllers([homeViewController], animated: false)
    }
    
    func onSelected(category: StretchType) { // Implementa o delegate
        
        print(category)
        
        let coordinator = StretchesCoordinator(
            (tabController.viewControllers!.first!), tabController,
            stretchType: category)
        
        coordinator.start()
        self.finish()
    }
}

class CategoriesCoordinator: Coordinator {
    
    var rootViewController: UIViewController {
        self.tabController
    }
    
    let tabController: UITabBarController
    
    override init() {
        self.tabController = UITabBarController()
    }

    override func start() {
        
        let story = UIStoryboard(name: "Categories", bundle: nil)
        let homeViewController = story.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        //homeViewController.delegate = self
        
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController")
        
        self.tabController.setViewControllers([
            homeViewController,
            profileViewController
        ], animated: false)
        
        
//        self.navigationController.setViewControllers([homeViewController], animated: false)
    }
    
//    func onSelected(category: TagCategory) {
//
//        print(category)
//
//        let coordinator = StretchesCoordinator(
//            self.tabController.viewControllers!.first! as! UINavigationController,
//            stretchType: .posture)
//
//        self.addChild(coordinator)
//
//        coordinator.start()
//        //self.finish()
//    }
}

class StretchesCoordinator: Coordinator {
    
    let sessionsRepository = FakeStretchesSessionRepository()
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
        
        self.navigationController.show(
            self.stretchViewController, sender: self)
    }
                                              
    func gotoNextSession() {
    
        let getNextSessionType = GetNextSessionType(sessionsRepository)
        
        let type = getNextSessionType.execute()
        
        let nextStretchViewModel = StretchesViewModel(
            type,
            self.sessionsRepository
        )
        
        self.stretchViewController.viewModel = nextStretchViewModel
        
        nextStretchViewModel.startSession()
        
        self.start()
    }
    
}

class OnboardingCoordinator: Coordinator {

    var navigationController: UINavigationController

    override init() {
        self.navigationController = UINavigationController()
    }

    override func start() {
        let onBoarding = UIHostingController(rootView: ContentView())
        self.navigationController.setViewControllers([onBoarding], animated: false)
    }
}
