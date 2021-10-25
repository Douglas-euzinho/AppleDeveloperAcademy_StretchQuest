//
//  CoreDataStretchesSessionsRepository.swift
//  Mini-Challenge-2
//
//  Created by Iorgers Almeida on 24/10/21.
//

import Foundation
import Core
import CoreData
import UIKit

extension StretchSession {
    
    static func from(
        model: StretchesSessions,
        using strechesRepository: StretchesRepository
    ) -> StretchSession {
        let type = StretchType(rawValue: Int(model.type))!
        
        return StretchSession(
            start: model.start,
            end: model.end,
            stretches: strechesRepository.list(filterBy: type),
            currentStretch: Int(model.currentStretch),
            type: type,
            pointIncrement: 1)
    }
    
}

class CoreDataStrechesSessionsRepository:
    StretchesSessionRepository {

    let context: NSManagedObjectContext
    
    let stretchesRepository = HardcodedStretchesRepository()
    
    public init() {
        self.context = (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
    }

    func list() -> [StretchSession] {

        print("[CoreDataStrechesSessionsRepository] list()")
        
        do {
            
            let stretchesRequest: NSFetchRequest<StretchesSessions> =
                StretchesSessions.fetchRequest()
            
            let allStretches =
                try self.context.fetch(stretchesRequest)
            
            let stretches = allStretches.map({ stretch in

                let type = StretchType(rawValue: Int(stretch.type))!

                return StretchSession(
                    start: stretch.start,
                    end: stretch.end,
                    stretches: stretchesRepository.list(filterBy: type),
                    currentStretch: Int(stretch.currentStretch),
                    type: type,
                    pointIncrement: 1)
                
            }) as [StretchSession]

            return stretches
            
        } catch {
            print(error)
            fatalError("in list()")
        }
        
    }

    func add(session: StretchSession) {
        
        print("[CoreDataStrechesSessionsRepository] add(session: \(session)")

        let newSession = StretchesSessions(context: self.context)
        
        newSession.currentStretch = Int64(session.currentStretch)
        newSession.start = session.start
        newSession.end = session.end
        newSession.type = Int64(session.type.rawValue)
        
        try? self.context.save()
        
    }

    func updateCurrentSession(to session: StretchSession) {

        print("[CoreDataStrechesSessionsRepository] updateCurrentSession(to session: \(session)")
        
        let request = StretchesSessions.fetchRequest()
        
        let dateSortDescriptor = NSSortDescriptor(
            key: #keyPath(StretchesSessions.start),
            ascending: false)
        
        request.sortDescriptors = [dateSortDescriptor]
      
        do {
            
            let sessions = try self.context.fetch(request) as [StretchesSessions]
            
            guard
                let currentSession = sessions.first
            else {
                fatalError("no current session found in coreData repository")
            }
            
            guard currentSession.end == nil else { fatalError ("end not nil") }
            
            currentSession.end = session.end
            currentSession.currentStretch = Int64(session.currentStretch)
            
            try? self.context.save()
            
        } catch {
            print(error)
            fatalError("in updateCurrentSession()")
        }
    }

    func getCurrentSession() -> StretchSession? {
        
        print("[CoreDataStrechesSessionsRepository] getCurrentSession()")
        
        let request = StretchesSessions.fetchRequest()
        
        let dateSortDescriptor = NSSortDescriptor(
            key: #keyPath(StretchesSessions.start),
            ascending: false)
        
        request.sortDescriptors = [dateSortDescriptor]
      
        do {
            
            let sessions = try self.context.fetch(request) as [StretchesSessions]
            
            guard
                let currentSession = sessions.first
            else {
                fatalError("no current session found in coreData repository")
            }
            
            guard currentSession.end == nil else { fatalError ("end not nil") }
            
            return StretchSession.from(
                model: currentSession,
                using: self.stretchesRepository)
            
        } catch {
            print(error)
            fatalError("in updateCurrentSession()")
        }
        
    }
}
