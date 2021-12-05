//
//  SwiftColor+MiniFlawless.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/4.
//

import UIKit

extension MiniFlawlessSteppable where Self: UIColor {
    
    private static func getHSB(_ value: Self) -> (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1
        
        value.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return (h, s, b, a)
    }
    
    private static func clamp(_ value: CGFloat) -> CGFloat {
        min(max(value, 0), 1.0)
    }
    
    public static var isClampable: Bool { true }
    
    public static var zero: Self {
        .init(white: 0, alpha: 1)
    }
    
    public var elements: Distance {
        let result = Self.getHSB(self)
        return [
            .init(result.h), .init(result.s),
            .init(result.b), .init(result.a)
        ]
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Distance {
        let lHSB = getHSB(lhs)
        let rHSB = getHSB(rhs)

        return [
            .init(lHSB.h - rHSB.h),
            .init(lHSB.s - rHSB.s),
            .init(lHSB.b - rHSB.b),
            .init(lHSB.a - rHSB.a)
        ]
    }
    
    public static func --+ (lhs: Self, rhs: Self) -> Self {
        let lHSB = getHSB(lhs)
        let rHSB = getHSB(rhs)

        return .init(
            hue:        clamp(lHSB.h + rHSB.h),
            saturation: clamp(lHSB.s + rHSB.s),
            brightness: clamp(lHSB.b + rHSB.b),
            alpha:      clamp(lHSB.a + rHSB.a)
        )
    }
    
    public static func --+ (lhs: Distance, rhs: Self) -> Self {
        distanceAdd(lhs: lhs, rhs: rhs)
    }
    
    public static func --+ (lhs: Self, rhs: Distance) -> Self {
        distanceAdd(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceAdd(lhs: Distance, rhs: Self) -> Self {
        guard lhs.count >= 4 else { return rhs }
        return .init(
            hue:        clamp(.init(lhs[0])),
            saturation: clamp(.init(lhs[1])),
            brightness: clamp(.init(lhs[2])),
            alpha:      clamp(.init(lhs[3]))
        ) --+ rhs
    }
    
    public static func --* <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        let rHSB = getHSB(rhs)

        return .init(
            hue:        clamp(.init(exactly: .init(lhs) * rHSB.h) ?? 0),
            saturation: clamp(.init(exactly: .init(lhs) * rHSB.s) ?? 0),
            brightness: clamp(.init(exactly: .init(lhs) * rHSB.b) ?? 0),
            alpha:      clamp(.init(exactly: .init(lhs) * rHSB.a) ?? 0)
        )
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        let rHSB = getHSB(rhs)

        return .init(
            hue:        clamp(.init(exactly: .init(lhs) * rHSB.h) ?? 0),
            saturation: clamp(.init(exactly: .init(lhs) * rHSB.s) ?? 0),
            brightness: clamp(.init(exactly: .init(lhs) * rHSB.b) ?? 0),
            alpha:      clamp(.init(exactly: .init(lhs) * rHSB.a) ?? 0)
        )
    }
    
}

extension UIColor: MiniFlawlessSteppable {  }

extension MiniFlawlessSteppable where Self: CGColor {
    
    private static func getHSB(_ value: Self) -> (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1
        
        UIColor.init(cgColor: value).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return (h, s, b, a)
    }
    
    private static func clamp(_ value: CGFloat) -> CGFloat {
        min(max(value, 0), 1.0)
    }
    
    public static var isClampable: Bool { true }
    
    public static var zero: Self {
        zeroValue()
    }
    
    public var elements: Distance {
        let result = Self.getHSB(self)
        return [
            .init(result.h), .init(result.s),
            .init(result.b), .init(result.a)
        ]
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Distance {
        let lHSB = getHSB(lhs)
        let rHSB = getHSB(rhs)

        return [
            .init(lHSB.h - rHSB.h),
            .init(lHSB.s - rHSB.s),
            .init(lHSB.b - rHSB.b),
            .init(lHSB.a - rHSB.a)
        ]
    }
    
    public static func --+ (lhs: Self, rhs: Self) -> Self {
        let lHSB = getHSB(lhs)
        let rHSB = getHSB(rhs)

        let result = UIColor.init(
            hue:        clamp(lHSB.h + rHSB.h),
            saturation: clamp(lHSB.s + rHSB.s),
            brightness: clamp(lHSB.b + rHSB.b),
            alpha:      clamp(lHSB.a + rHSB.a)
        ).cgColor
        
        return (result as? Self) ?? zeroValue()
    }
    
    public static func --+ (lhs: Distance, rhs: Self) -> Self {
        distanceAdd(lhs: lhs, rhs: rhs)
    }
    
    public static func --+ (lhs: Self, rhs: Distance) -> Self {
        distanceAdd(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceAdd(lhs: Distance, rhs: Self) -> Self {
        guard lhs.count >= 4 else { return rhs }
        return (
            (UIColor.init(
                hue:        clamp(.init(lhs[0])),
                saturation: clamp(.init(lhs[1])),
                brightness: clamp(.init(lhs[2])),
                alpha:      clamp(.init(lhs[3]))
            ).cgColor as? Self) ?? zeroValue()
        ) --+ rhs
    }
    
    public static func --* <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        let rHSB = getHSB(rhs)

        let result = UIColor.init(
            hue:        clamp(.init(exactly: .init(lhs) * rHSB.h) ?? 0),
            saturation: clamp(.init(exactly: .init(lhs) * rHSB.s) ?? 0),
            brightness: clamp(.init(exactly: .init(lhs) * rHSB.b) ?? 0),
            alpha:      clamp(.init(exactly: .init(lhs) * rHSB.a) ?? 0)
        ).cgColor
        
        return (result as? Self) ?? zeroValue()
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        let rHSB = getHSB(rhs)

        let result = UIColor.init(
            hue:        clamp(.init(exactly: .init(lhs) * rHSB.h) ?? 0),
            saturation: clamp(.init(exactly: .init(lhs) * rHSB.s) ?? 0),
            brightness: clamp(.init(exactly: .init(lhs) * rHSB.b) ?? 0),
            alpha:      clamp(.init(exactly: .init(lhs) * rHSB.a) ?? 0)
        ).cgColor
        
        return (result as? Self) ?? zeroValue()
    }
    
    private static func zeroValue() -> Self {
        UIColor.black.cgColor as! Self
    }
    
}

extension CGColor: MiniFlawlessSteppable {  }

extension MiniFlawlessSteppable where Self: CIColor {
    
    private static func getHSB(_ value: Self) -> (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1
        
        UIColor.init(ciColor: value).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return (h, s, b, a)
    }
    
    private static func clamp(_ value: CGFloat) -> CGFloat {
        min(max(value, 0), 1.0)
    }
    
    public static var isClampable: Bool { true }
    
    public static var zero: Self {
        zeroValue()
    }
    
    public var elements: Distance {
        let result = Self.getHSB(self)
        return [
            .init(result.h), .init(result.s),
            .init(result.b), .init(result.a)
        ]
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Distance {
        let lHSB = getHSB(lhs)
        let rHSB = getHSB(rhs)

        return [
            .init(lHSB.h - rHSB.h),
            .init(lHSB.s - rHSB.s),
            .init(lHSB.b - rHSB.b),
            .init(lHSB.a - rHSB.a)
        ]
    }
    
    public static func --+ (lhs: Self, rhs: Self) -> Self {
        let lHSB = getHSB(lhs)
        let rHSB = getHSB(rhs)

        let result = UIColor.init(
            hue:        clamp(lHSB.h + rHSB.h),
            saturation: clamp(lHSB.s + rHSB.s),
            brightness: clamp(lHSB.b + rHSB.b),
            alpha:      clamp(lHSB.a + rHSB.a)
        ).ciColor
        
        return (result as? Self) ?? zeroValue()
    }
    
    public static func --+ (lhs: Distance, rhs: Self) -> Self {
        distanceAdd(lhs: lhs, rhs: rhs)
    }
    
    public static func --+ (lhs: Self, rhs: Distance) -> Self {
        distanceAdd(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceAdd(lhs: Distance, rhs: Self) -> Self {
        guard lhs.count >= 4 else { return rhs }
        return (
            (UIColor.init(
                hue:        clamp(.init(lhs[0])),
                saturation: clamp(.init(lhs[1])),
                brightness: clamp(.init(lhs[2])),
                alpha:      clamp(.init(lhs[3]))
            ).ciColor as? Self) ?? zeroValue()
        ) --+ rhs
    }
    
    public static func --* <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        let rHSB = getHSB(rhs)

        let result = UIColor.init(
            hue:        clamp(.init(exactly: .init(lhs) * rHSB.h) ?? 0),
            saturation: clamp(.init(exactly: .init(lhs) * rHSB.s) ?? 0),
            brightness: clamp(.init(exactly: .init(lhs) * rHSB.b) ?? 0),
            alpha:      clamp(.init(exactly: .init(lhs) * rHSB.a) ?? 0)
        ).ciColor
        
        return (result as? Self) ?? zeroValue()
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        let rHSB = getHSB(rhs)

        let result = UIColor.init(
            hue:        clamp(.init(exactly: .init(lhs) * rHSB.h) ?? 0),
            saturation: clamp(.init(exactly: .init(lhs) * rHSB.s) ?? 0),
            brightness: clamp(.init(exactly: .init(lhs) * rHSB.b) ?? 0),
            alpha:      clamp(.init(exactly: .init(lhs) * rHSB.a) ?? 0)
        ).ciColor
        
        return (result as? Self) ?? zeroValue()
    }
    
    private static func zeroValue() -> Self {
        UIColor.black.ciColor as! Self
    }
    
}

extension CIColor: MiniFlawlessSteppable {  }
