//
//  ImageDataBaseHelp.swift
//  Mini-Challenge-2
//
//  Created by Douglas Figueirôa on 27/10/21.
//

import Foundation
import UIKit
import CoreData
import CoreMedia

class DatabaseUser{
    
    static let instance = DatabaseUser()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var user: User?
    
    init() {
        do {
            let fetchRequest = User.fetchRequest() as NSFetchRequest<User>
            let users = try context.fetch(fetchRequest)
            
            user = users.first
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveImageInCore(_ img: Data) {
        if user == nil {
            createNewUser()
        }
        
        user!.imageProfile = img
    }
    
    func saveNameInCore(_ name: String) {
        if user == nil {
            createNewUser()
        }
        
        user!.name = name
    }
    
    private func createNewUser() {
        user = User(context: context)
    }
    
}
