//
//  GetNextSessionType.swift
//  Core
//
//  Created by Iorgers Almeida on 22/10/21.
//

import Foundation

public protocol GetNextSessionTypeIteractor {
    func execute() -> StretchType
}

public class GetNextSessionType:
    GetNextSessionTypeIteractor {

    let repository: StretchesSessionRepository

    public init(
        _ repository: StretchesSessionRepository
    ){
        self.repository = repository
    }

    public func execute() -> StretchType {

        let allOptions = StretchType.allCases

        // Get the last session choices in a interval of 24h
        let lastChoices = self.repository.list().suffix(2).map({ $0.type })

        var availableOptions = Set(allOptions)
        
        lastChoices.forEach({ type in availableOptions.remove(type) })
        
        let random = availableOptions.randomElement()
        
        guard
            let nextSessionStretcheType = random
        else {
            fatalError("MUST NEVER HAPPEN!")
        }
        
        return nextSessionStretcheType
    }

}
