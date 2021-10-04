//
//  AppCoordinator.swift
//  Mini-Challenge-2
//
//  Created by Daniel Gomes Ribeiro on 04/10/21.
//

import Foundation
import UIKit
import SwiftUI

class AppCoordinator {
    
    var rootViewController: UINavigationController
    var didShowUserOnboard = UserDefaults.standard.bool(forKey: "alreadyEntry")

    
    init(rootViewController: UINavigationController) {
        
        self.rootViewController =  rootViewController
    }
    
    func configureHomeScreen() {
        
        var vc: UIViewController
        
        if !didShowUserOnboard {
            let story = UIStoryboard(name: "Main", bundle:nil)
            vc = story.instantiateViewController(withIdentifier: "HomeViewController")
        } else {
            vc = UIHostingController(rootView: ContentView())
            //UserDefaults.standard.setValue(true, forKey: "alreadyEntry")
        }
        
        rootViewController.setViewControllers([vc], animated: false)
    }
    
}
