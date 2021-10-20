//
//  SessionProgress.swift
//  Core
//
//  Created by Iorgers Almeida on 19/10/21.
//

import Foundation

public struct SessionProgress: CustomStringConvertible {
    
    let current: Int
    let total: Int
    
    public var description: String {
        "\(current)/\(total)"
    }
    
    public var isDone: Bool {
        self.current >= self.total
    }
    
    public init(
        _ current: Int,
        _ total: Int
    ){
        self.current = current
        self.total = total
    }
}
