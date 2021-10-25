//
//  GetUserAttributesIteractor.swift
//  Core
//
//  Created by Iorgers Almeida on 13/10/21.
//

import Foundation

// MARK: - Protocols de repositórios

public enum StretchSessionFilter {
    case all
    case completed
}

public protocol UserAttributesRepository: AnyObject { // Abstração para o "acesso" aos dados do Core Data
    func getAttributes() -> StretchPoints
    func save(attributes: StretchPoints) -> Void
}

public protocol StretchesSessionRepository: AnyObject { // Abstração para o "acesso" aos dados do Core Data
    func list() -> [StretchSession]
    func add(session: StretchSession) -> Void
    func updateCurrentSession(to session: StretchSession) -> Void
    func getCurrentSession() -> StretchSession?
}

// MARK: - GetUserAttributesIteractor - Será usado para mostrar os pontos de atributo do usuário

public protocol GetUserAttributesResult: AnyObject {
    var userAttributes: StretchPoints { get set }
}

public protocol GetUserAttributesIteractor: AnyObject {
    func execute(_ result: GetUserAttributesResult) -> Void
}

public class GetUserAttributes: GetUserAttributesIteractor {
    
    let repository: UserAttributesRepository
    
    public init(_ repository: UserAttributesRepository){
        self.repository = repository
    }
    
    public func execute(_ result: GetUserAttributesResult) {
        
        let userAttributes = self.repository.getAttributes()
        
        result.userAttributes = userAttributes
        
    }
    
}

public class FakeUserAttributesRepository: UserAttributesRepository {
    
    var points: StretchPoints
    
    public init () {
        self.points = StretchPoints(strength: 0, posture: 0, flexibility: 0)
    }
    
    public func getAttributes() -> StretchPoints {
        return self.points
    }
    
    public func save(attributes: StretchPoints) {
        self.points = attributes
    }
    
}

public class FakeGetUserAttributesResult: GetUserAttributesResult {
    public var userAttributes: StretchPoints = StretchPoints.empty {
        didSet {
            print("[FakeGetUserAttributesResult] didSet userAtrributes: \(self.userAttributes)")
        }
    }
    
    public init () {}
}

// MARK: - Testing

public class FakeStretchesSessionRepository: StretchesSessionRepository {

    var stretchesSessions = [StretchSession]()
    
    public init () {}
    
    public func list() -> [StretchSession] {
        self.stretchesSessions
    }
    
    public func add(session: StretchSession) -> Void {
        self.stretchesSessions.append(session)
    }

    public func updateCurrentSession(to session: StretchSession) {
        self.stretchesSessions.remove(at: self.stretchesSessions.count - 1)
        self.stretchesSessions.append(session)
    }
    
    public func getCurrentSession() -> StretchSession? {
        self.stretchesSessions.last!
    }
}

public class GetUserAttributesVersion2: GetUserAttributesIteractor {
    
    let repository: StretchesSessionRepository
    
    public init(_ repository: StretchesSessionRepository){
        self.repository = repository
    }
    
    public func execute(_ result: GetUserAttributesResult) {
        
        var flexibility = 0
        var strength = 0
        var posture = 0
        
        let sessions = self.repository.list().filter({
            $0.end != nil
        })
        
        sessions.forEach({
            switch($0.type){
            case .flexibility:
                flexibility += 1
            case .posture:
                posture += 1
            case .strength:
                strength += 1
            }
        })
        
        let userAttributes = StretchPoints(
            strength: strength,
            posture: posture,
            flexibility: flexibility)
        
        result.userAttributes = userAttributes
        
    }
    
}
