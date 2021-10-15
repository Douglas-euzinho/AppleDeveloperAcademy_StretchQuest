//
//  Atributes+CoreDataProperties.swift
//  Mini-Challenge-2
//
//  Created by Douglas Figueirôa on 15/10/21.
//
//

import Foundation
import CoreData


extension Atributes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Atributes> {
        return NSFetchRequest<Atributes>(entityName: "Atributes")
    }

    @NSManaged public var flexibility: NSObject?
    @NSManaged public var strength: NSObject?
    @NSManaged public var posture: NSObject?
    @NSManaged public var user: User?

}

extension Atributes : Identifiable {

}
