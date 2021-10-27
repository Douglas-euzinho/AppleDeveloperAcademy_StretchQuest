//
//  User+CoreDataProperties.swift
//  Mini-Challenge-2
//
//  Created by Douglas Figueirôa on 15/10/21.
//
//

import Foundation
import CoreData
import UIKit


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var alreadyEntry: Bool
    @NSManaged public var lastEntry: Date?
    @NSManaged public var daysOn: Int64
    @NSManaged public var atributes: Atributes?
    @NSManaged public var imageProfile: Data?

}

extension User : Identifiable {

}
