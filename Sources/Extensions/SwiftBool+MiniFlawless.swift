//
//  SwiftBool+MiniFlawless.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/4.
//

import Foundation

//extension Int {
//    fileprivate var bool: Bool { self == 1 : true : false }
//}
//
//extension Bool: MiniFlawlessSteppable {
//    
//    fileprivate var int: Int { self ? 1 : 0 }
//    
//    public static var isClampable: Bool { false }
//    
//    public var zero: Self { false }
//    
//    public var elements: Distance { [ int ] }
//    
//    public static prefix func --- (value: Self) -> Self {
//        value.int == 0 ? true : false
//    }
//    
//    public static func --- (lhs: Self, rhs: Self) -> Self {
//        (lhs.int - rhs.int).bool
//    }
//    
//    public static func ---> (lhs: Self, rhs: Self) -> Distance {
//        [ lhs.int - rhs.int ]
//    }
//    
//    
//    public static func --+ (lhs: Self, rhs: Self) -> Self {
//        lhs + rhs
//    }
//    
//    public static func --+ (lhs: Distance, rhs: Self) -> Self {
//        distanceAdd(lhs: lhs, rhs: rhs)
//    }
//    
//    public static func --+ (lhs: Self, rhs: Distance) -> Self {
//        distanceAdd(lhs: rhs, rhs: lhs)
//    }
//    
//    public static func distanceAdd (lhs: Distance, rhs: Self) -> Self {
//        guard lhs.count >= 1 else { return rhs }
//        return .init(exactly: round(lhs[0]) + .init(rhs)) ?? 0
//    }
//    
//    
//    public static func --* <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
//        distanceMultiply(lhs: lhs, rhs: rhs)
//    }
//    
//    public static func --* <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
//        distanceMultiply(lhs: rhs, rhs: lhs)
//    }
//    
//    private static func distanceMultiply<I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
//        .init(clamping: lhs) * rhs
//    }
//    
//    public static func --* <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
//        distanceMultiply(lhs: lhs, rhs: rhs)
//    }
//    
//    public static func --* <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
//        distanceMultiply(lhs: rhs, rhs: lhs)
//    }
//    
//    private static func distanceMultiply<F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
//        .init(exactly: round(lhs) * .init(rhs)) ?? 0
//    }
//    
//    
//    public static func --/ <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
//        distanceDivide(lhs: lhs, rhs: rhs)
//    }
//    
//    public static func --/ <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
//        distanceDivide(lhs: rhs, rhs: lhs)
//    }
//    
//    private static func distanceDivide<I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
//        .init(clamping: lhs) / rhs
//    }
//    
//    public static func --/ <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
//        distanceDivide(lhs: lhs, rhs: rhs)
//    }
//    
//    public static func --/ <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
//        distanceDivide(lhs: rhs, rhs: lhs)
//    }
//    
//    private static func distanceDivide<F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
//        .init(exactly: round(lhs) / .init(rhs)) ?? 0
//    }
//    
//}
//
//extension Bool: MiniFlawlessMechanicsSteppable {
//    
//    public var length: Double {
//        .init(self)
//    }
//    
//    public func distance(toSegment segment: (from: Self, to: Self)) -> Double {
//        let from = abs(Int64(self) - Int64(segment.from))
//        let to = abs(Int64(self) - Int64(segment.to))
//        return Double(min(from, to))
//    }
//    
//}
