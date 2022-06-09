//
//  SwiftFloating+MiniFlawless.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/4.
//

import Foundation

extension MiniFlawlessSteppable where Self: BinaryFloatingPoint {
    
    public static var isClampable: Bool { false }
    
    public var elements: Distance { [.init(self)] }
    
    public static prefix func --- (value: Self) -> Self {
        .zero - value
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Self {
        .init(lhs - rhs)
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
    
    private static func distanceAdd(lhs: Distance, rhs: Self) -> Self {
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
        .init(exactly: Double(lhs) * Double(rhs)) ?? 0
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
        .init(exactly: Double(lhs) / Double(rhs)) ?? 0
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        .init(exactly: Double(lhs) / Double(rhs)) ?? 0
    }
    
}

extension Float: MiniFlawlessSteppable   { }
@available(iOS 14.0, macOS 11.0, *)
extension Float16: MiniFlawlessSteppable { }
#if os(macOS)
@available(macOS 10.10, *)
extension Float80: MiniFlawlessSteppable { }
#endif
extension Double: MiniFlawlessSteppable  { }


extension MiniFlawlessMechanicsSteppable where Self: BinaryFloatingPoint {
    
    public var length: Double {
        .init(exactly: Swift.abs(self)) ?? 0
    }
    
    public func distance(toSegment segment: (from: Self, to: Self)) -> Double {
        Double(min(abs(self - segment.from), abs(self - segment.to)))
    }
    
}

extension Float: MiniFlawlessMechanicsSteppable   { }
@available(iOS 14.0, macOS 11.0, *)
extension Float16: MiniFlawlessMechanicsSteppable { }
#if os(macOS)
@available(macOS 10.10, *)
extension Float80: MiniFlawlessMechanicsSteppable { }
#endif
extension Double: MiniFlawlessMechanicsSteppable  { }
