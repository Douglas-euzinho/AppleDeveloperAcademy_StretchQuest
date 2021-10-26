//
//  ProfileViewModel.swift
//  Mini-Challenge-2
//
//  Created by Iorgers Almeida on 25/10/21.
//

import Foundation
import Core

class ProfileViewModel {
 
    // MARK: Depencies
    
    let getUserAttributes: GetUserAttributesIteractor
 
    // MARK: Published properties
    
    var userAttributes: StretchPoints = StretchPoints.empty {
        didSet{
            self.didPublish()
        }
    }
    
    // MARK: Publisher
    
    var didPublish: () -> () = {}
    
    init(
        _ stretchesSessionRepository: StretchesSessionRepository
    ) {
        self.getUserAttributes = GetUserAttributesVersion2(stretchesSessionRepository)
    }
    
    func requestCurrentUserAttributes() {
        self.getUserAttributes.execute(self)
    }
}

extension ProfileViewModel: GetUserAttributesResult {}
