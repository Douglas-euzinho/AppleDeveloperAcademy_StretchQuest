//
//  User+CoreDataProperties.swift
//  Mini-Challenge-2
//
//  Created by Douglas Figueirôa on 27/10/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var alreadyEntry: Bool
    @NSManaged public var daysOn: Int64
    @NSManaged public var imageProfile: Data?
    @NSManaged public var lastEntry: Date?
    @NSManaged public var name: String?
    @NSManaged public var atributes: Atributes?

}

extension User : Identifiable {

}
