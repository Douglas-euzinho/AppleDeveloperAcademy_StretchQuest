//
//  AppCoordinator.swift
//  Mini-Challenge-2
//
//  Created by Daniel Gomes Ribeiro on 04/10/21.
//

import UIKit
import SwiftUI
import Core

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
        print("Coordinator foi alocado!")
        super.init()
    }
    
    deinit {
        print("Coordinator foi desalocado!")
    }
}

// MARK: - Implementações de Coordinators

class AppCoordinator: Coordinator {

    var navigationController: UINavigationController
    var didShowUserOnboard = UserDefaults.standard.bool(forKey: "alreadyEntry")

    init(rootViewController: UINavigationController) {
        self.navigationController = rootViewController
    }

    override func start() {
        
        if !didShowUserOnboard {
           let coordinator = MainCoordinator(self.navigationController)
           addChild(coordinator)
           coordinator.start()
       } else {
           let coordinator = OnboardingCoordinator(self.navigationController)
           addChild(coordinator)
           coordinator.start()
        }
        
        self.navigationController.setNavigationBarHidden(true, animated: true)
    }

}

class MainCoordinator: Coordinator, CategoriesDelegate {
    
    var navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        let story = UIStoryboard(name: "Categories", bundle:nil)
        let homeViewController = story.instantiateViewController(withIdentifier: "CategoriesView") as! CategoriesViewController
        
        homeViewController.delegate = self
        self.navigationController.setViewControllers([homeViewController], animated: false)
    }
    
    func onSelected(category: TagCategory) {
        let coordinator = StretchesCoordinator(
            self.navigationController,
            stretchType: .posture)
        
        coordinator.start()
        self.finish()
    }
}

class StretchesCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var stretchViewController: StretchViewController

    init(
        _ navigationController: UINavigationController,
        stretchType: StretchType
    ) {
        self.navigationController = navigationController
        
        let story = UIStoryboard(name: "Stretch", bundle:nil)
        let stretchViewController =
            story.instantiateViewController(withIdentifier: "StretchView") as! StretchViewController
        
        let viewModel = StretchesViewModel()
        
        stretchViewController.viewModel = viewModel
        
        self.stretchViewController = stretchViewController
    }
    
    override func start() {
        self.navigationController.setViewControllers([self.stretchViewController], animated: true)
        //self.navigationController.pushViewController(self.stretchViewController, animated: true)
    }
    
}

class OnboardingCoordinator: Coordinator {

    var navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        let onBoarding = UIHostingController(rootView: ContentView())
        self.navigationController.setViewControllers([onBoarding], animated: false)
    }
}
