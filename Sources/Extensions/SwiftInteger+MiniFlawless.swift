//
//  SwiftInteger+MiniFlawless.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/4.
//

import Foundation

extension MiniFlawlessSteppable where Self: BinaryInteger {
    
    public static var isClampable: Bool { false }
    
    public var elements: Distance { [.init(self)] }
    
    public static prefix func --- (value: Self) -> Self {
        .zero - value
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Self {
        .init(exactly: Double(lhs) - Double(rhs)) ?? 0
    }
    
    public static func ---> (lhs: Self, rhs: Self) -> Distance {
        [.init(lhs - rhs)]
    }
    
    
    public static func --+ (lhs: Self, rhs: Self) -> Self {
        lhs + rhs
    }
    
    public static func --+ (lhs: Distance, rhs: Self) -> Self {
        distanceAdd(lhs: lhs, rhs: rhs)
    }
    
    public static func --+ (lhs: Self, rhs: Distance) -> Self {
        distanceAdd(lhs: rhs, rhs: lhs)
    }
    
    public static func distanceAdd (lhs: Distance, rhs: Self) -> Self {
        guard lhs.count >= 1 else { return rhs }
        return .init(exactly: Double(lhs[0]) + Double(rhs)) ?? 0
    }
    
    
    public static func --* <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(clamping: lhs) * rhs
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        .init(exactly: Double(lhs) * Double(rhs)) ?? 0
    }
    
    
    public static func --/ <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(exactly: Double(lhs) / Double(rhs)) ?? 0
    }
    
    public static func --/ <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        .init(exactly: Double(lhs) / Double(rhs)) ?? 0
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        .init(exactly: Double(lhs) / Double(rhs) ) ?? 0
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        .init(exactly: Double(lhs) / Double(rhs)) ?? 0
    }
    
}

extension Int: MiniFlawlessSteppable   { }
extension Int8: MiniFlawlessSteppable  { }
extension Int16: MiniFlawlessSteppable { }
extension Int32: MiniFlawlessSteppable { }
extension Int64: MiniFlawlessSteppable { }

extension UInt: MiniFlawlessSteppable   { }
extension UInt8: MiniFlawlessSteppable  { }
extension UInt16: MiniFlawlessSteppable { }
extension UInt32: MiniFlawlessSteppable { }
extension UInt64: MiniFlawlessSteppable { }


extension MiniFlawlessMechanicsSteppable where Self: BinaryInteger {
    
    public var length: Double {
        .init(self)
    }
    
    public func distance(toSegment segment: (from: Self, to: Self)) -> Double {
        let from = abs(Int64(self) - Int64(segment.from))
        let to = abs(Int64(self) - Int64(segment.to))
        return Double(min(from, to))
    }
    
}

extension MiniFlawlessMechanicsSteppable where Self: BinaryInteger & SignedNumeric {
    
    public var length: Double {
        .init(exactly: Swift.abs(self)) ?? 0
    }
    
}

extension Int: MiniFlawlessMechanicsSteppable   { }
extension Int8: MiniFlawlessMechanicsSteppable  { }
extension Int16: MiniFlawlessMechanicsSteppable { }
extension Int32: MiniFlawlessMechanicsSteppable { }
extension Int64: MiniFlawlessMechanicsSteppable { }

extension UInt: MiniFlawlessMechanicsSteppable   { }
extension UInt8: MiniFlawlessMechanicsSteppable  { }
extension UInt16: MiniFlawlessMechanicsSteppable { }
extension UInt32: MiniFlawlessMechanicsSteppable { }
extension UInt64: MiniFlawlessMechanicsSteppable { }
