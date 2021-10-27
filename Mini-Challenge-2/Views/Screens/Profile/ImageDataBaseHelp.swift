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


class ImageDataBaseHelp{
    
    static let instancePhoto = ImageDataBaseHelp()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImageInCore(at img: Data){
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        user.imageProfile = img
        do{
            try context.save()
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func getAllImages() -> [User]{
        var arrUser = [User]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do{
            arrUser = try context.fetch(fetchRequest) as! [User]
        }catch let error{
            print(error.localizedDescription)
        }
        return arrUser
    }
}
