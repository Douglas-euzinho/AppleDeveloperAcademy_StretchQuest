//
//  SessionProgress.swift
//  Core
//
//  Created by Iorgers Almeida on 19/10/21.
//

import Foundation

public struct TaskProgress: CustomStringConvertible {
    
    public let current: Int
    public let total: Int
    
    public var description: String {
        "\(current)/\(total)"
    }
    
    public var isFirst: Bool {
        self.current == 1
    }
    
    public var isDone: Bool {
        self.current == total
    }
    
    public init(total: Int){
        self.current = 1
        self.total = total
    }
    
    public init(
        _ current: Int,
        _ total: Int
    ){
        self.current = current
        self.total = total
    }
    
}

public struct SessionProgress {
    
    public let aparent: TaskProgress
    public let real: TaskProgress
    
    public var isDone: Bool {
        real.isDone
    }
    
    public init(
        real: TaskProgress,
        aparent: TaskProgress
    ){
        self.real = real
        self.aparent = aparent
    }
    
    public init(
        totalReal: Int,
        totalAparent: Int
    ){
        self.real = TaskProgress(total: totalReal)
        self.aparent = TaskProgress(total: totalAparent)
    }
    
    public static let empty = SessionProgress(totalReal: 0, totalAparent: 0)
}
