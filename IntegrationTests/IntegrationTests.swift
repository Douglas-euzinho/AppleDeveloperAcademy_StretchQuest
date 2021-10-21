//
//  IntegrationTests.swift
//  IntegrationTests
//
//  Created by Iorgers Almeida on 19/10/21.
//

import XCTest
import Core
@testable import Mini_Challenge_2

class IntegrationTests: XCTestCase {

    func testFullStretchSession() {
        
        let viewModel = StretchesViewModel(category: .posture)
        
        let listener = FakeStretchListener()
        
        viewModel.listener = listener
        
        viewModel.startSession()
        
        //TODO: Refactor to get the real total of stretches instead of using a while loop
        
        while(!(listener.currentProgress?.isDone ?? true)){
            viewModel.nextStretch()
        }
        
        //TODO: Add more assertions
        
        XCTAssert(listener.currentProgress?.isDone ?? false)
    }
    
    func testTransitionViewModel() {
        
        let viewModel = TransitionViewModel()
        
        viewModel.start()
        
    }

}
