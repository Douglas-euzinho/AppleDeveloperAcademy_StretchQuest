//
//  HomeViewControllerRepresentable.swift
//  Mini-Challenge-2
//
//  Created by Daniel Gomes Ribeiro on 24/10/21.
//

import Foundation
import SwiftUI

struct MainHomeViewController: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = CategoriesViewController

    func makeUIViewController(context: Context) -> CategoriesViewController {
        let story = UIStoryboard(name: "Main", bundle:nil)
        return story.instantiateViewController(withIdentifier: "HomeViewController") as! CategoriesViewController
    }
    
    func updateUIViewController(_ uiViewController: CategoriesViewController, context: Context) {
    
    }
}



