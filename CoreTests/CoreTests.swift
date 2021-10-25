//
//  CoreTests.swift
//  CoreTests
//
//  Created by Iorgers Almeida on 13/10/21.
//

import XCTest
@testable import Core
@testable import Mini_Challenge_2

class CoreTests: XCTestCase {

    func testGetUserAttributes() throws {
       
        let result = FakeGetUserAttributesResult()
        
        let repository = FakeUserAttributesRepository()
        
        repository.save(attributes: StretchPoints(strength: 10, posture: 0, flexibility: 3))
        
        let service = GetUserAttributes(repository)
        
        service.execute(result)
    }
    
    func testGetUserAttributesVersion2() throws {
        
        let result = FakeGetUserAttributesResult()
        
        let repository = FakeStretchesSessionRepository()
        
        repository.add(session: StretchSession.flexibility)
        repository.add(session: StretchSession.posture)
        repository.add(session: StretchSession.strength)
        repository.add(session: StretchSession.strength)
        
        let service = GetUserAttributesVersion2(repository)
        
        service.execute(result)
        
    }
    
    func testGetNextSessionType() {
        
        let repository = FakeStretchesSessionRepository()

        repository.add(session: StretchSession.flexibility)
        repository.add(session: StretchSession.posture)
        
        let service = GetNextSessionType(repository)
        
        XCTAssertEqual(service.execute(), .strength)
    }

}
