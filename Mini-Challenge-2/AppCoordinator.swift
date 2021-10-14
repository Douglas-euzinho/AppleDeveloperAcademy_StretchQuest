//
//  AppCoordinator.swift
//  Mini-Challenge-2
//
//  Created by Daniel Gomes Ribeiro on 04/10/21.
//

import Foundation
import UIKit
import SwiftUI

protocol Coordinator {
    var rootViewController: UIViewController { get }
    func start()
}

class AppCoordinator: Coordinator {

    var rootViewController: UIViewController {
        self.navigationController
    }

    var navigationController: UINavigationController
    var didShowUserOnboard = UserDefaults.standard.bool(forKey: "alreadyEntry")

    init(rootViewController: UINavigationController) {
        self.navigationController = rootViewController
    }

    func start() {
        if !didShowUserOnboard {
            let coortinator = MainCoordinator(self.navigationController)
            coortinator.start()
       } else {
            let coordinator = OnboardingCoordinator(self.navigationController)
            coordinator.start()
        }
    }

}

class MainCoordinator: Coordinator {

    var rootViewController: UIViewController = UIViewController()
    var navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        //let story = UIStoryboard(name: "Categories", bundle: nil)
        //vc = story.instantiateViewController(withIdentifier: "CategoriesViewController")
        let story = UIStoryboard(name: "Categories", bundle:nil)
        let homeViewController = story.instantiateViewController(withIdentifier: "CategoriesViewController")
        self.navigationController.setViewControllers([homeViewController], animated: false)
    }
}

class OnboardingCoordinator: Coordinator {

    var rootViewController: UIViewController = UIViewController()
    var navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let onBoarding = UIHostingController(rootView: ContentView())
        self.navigationController.setViewControllers([onBoarding], animated: false)
    }
}
