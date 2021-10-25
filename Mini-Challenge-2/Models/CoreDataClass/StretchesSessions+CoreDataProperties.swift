//
//  StretchesSessions+CoreDataProperties.swift
//  Mini-Challenge-2
//
//  Created by Iorgers Almeida on 24/10/21.
//
//

import Foundation
import CoreData


extension StretchesSessions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StretchesSessions> {
        return NSFetchRequest<StretchesSessions>(entityName: "StretchesSessions")
    }

    @NSManaged public var start: Date
    @NSManaged public var end: Date?
    @NSManaged public var type: Int64
    @NSManaged public var currentStretch: Int64

}

extension StretchesSessions : Identifiable {

}
