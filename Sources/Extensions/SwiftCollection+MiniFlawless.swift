//
//  SwiftCollection+MiniFlawless.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/4.
//

import Foundation

extension Array where Self.Element: MiniFlawlessSteppable {
    
    public static func --* (lhs: TimeInterval, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* (lhs: Self, rhs: TimeInterval) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply(lhs: TimeInterval, rhs: Self) -> Self {
        rhs.map { lhs --* $0 }
    }
    
}
