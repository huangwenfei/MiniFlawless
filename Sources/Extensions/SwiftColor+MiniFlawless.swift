//
//  SwiftColor+MiniFlawless.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/4.
//

import UIKit

extension UIColor {
    
    fileprivate var getHSB: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1
        
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return (h, s, b, a)
    }
    
}

extension MiniFlawlessSteppable where Self: UIColor {
    
    private static func clamp(_ value: CGFloat) -> CGFloat {
        min(max(value, 0), 1.0)
    }
    
    public static var isClampable: Bool { true }
    
    public static var zero: Self {
        .init(white: 0, alpha: 1)
    }
    
    public var elements: Distance {
        let result = getHSB
        return [
            .init(result.h), .init(result.s),
            .init(result.b), .init(result.a)
        ]
    }
    
    public static prefix func --- (value: Self) -> Self {
        let v = value.getHSB
        return .init(hue: 1.0 - v.h, saturation: 1.0 - v.s, brightness: 1.0 - v.b, alpha: 1.0 - v.a)
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Self {
        let lHSB = lhs.getHSB
        let rHSB = rhs.getHSB

        return .init(
            hue:        clamp(lHSB.h - rHSB.h),
            saturation: clamp(lHSB.s - rHSB.s),
            brightness: clamp(lHSB.b - rHSB.b),
            alpha:      clamp(lHSB.a - rHSB.a)
        )
    }
    
    public static func ---> (lhs: Self, rhs: Self) -> Distance {
        let lHSB = lhs.getHSB
        let rHSB = rhs.getHSB

        return [
            .init(lHSB.h - rHSB.h),
            .init(lHSB.s - rHSB.s),
            .init(lHSB.b - rHSB.b),
            .init(lHSB.a - rHSB.a)
        ]
    }
    
    
    public static func --+ (lhs: Self, rhs: Self) -> Self {
        let lHSB = lhs.getHSB
        let rHSB = rhs.getHSB

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
            hue:        clamp(CGFloat(lhs[0])),
            saturation: clamp(CGFloat(lhs[1])),
            brightness: clamp(CGFloat(lhs[2])),
            alpha:      clamp(CGFloat(lhs[3]))
        ) --+ rhs
    }
    
    
    public static func --* <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        let rHSB = rhs.getHSB

        return .init(
            hue:        clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.h) ?? 0),
            saturation: clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.s) ?? 0),
            brightness: clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.b) ?? 0),
            alpha:      clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.a) ?? 0)
        )
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        let rHSB = rhs.getHSB

        return .init(
            hue:        clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.h) ?? 0),
            saturation: clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.s) ?? 0),
            brightness: clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.b) ?? 0),
            alpha:      clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.a) ?? 0)
        )
    }
    
    
    public static func --/ <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        let rHSB = rhs.getHSB

        return .init(
            hue:        clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.h) ?? 0),
            saturation: clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.s) ?? 0),
            brightness: clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.b) ?? 0),
            alpha:      clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.a) ?? 0)
        )
    }
    
    public static func --/ <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        let lHSB = lhs.getHSB

        return .init(
            hue:        clamp(CGFloat(exactly: lHSB.h / CGFloat(rhs)) ?? 0),
            saturation: clamp(CGFloat(exactly: lHSB.s / CGFloat(rhs)) ?? 0),
            brightness: clamp(CGFloat(exactly: lHSB.b / CGFloat(rhs)) ?? 0),
            alpha:      clamp(CGFloat(exactly: lHSB.a / CGFloat(rhs)) ?? 0)
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        let rHSB = rhs.getHSB

        return .init(
            hue:        clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.h) ?? 0),
            saturation: clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.s) ?? 0),
            brightness: clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.b) ?? 0),
            alpha:      clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.a) ?? 0)
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        let lHSB = lhs.getHSB

        return .init(
            hue:        clamp(CGFloat(exactly: lHSB.h / CGFloat(rhs)) ?? 0),
            saturation: clamp(CGFloat(exactly: lHSB.s / CGFloat(rhs)) ?? 0),
            brightness: clamp(CGFloat(exactly: lHSB.b / CGFloat(rhs)) ?? 0),
            alpha:      clamp(CGFloat(exactly: lHSB.a / CGFloat(rhs)) ?? 0)
        )
    }
    
}

extension MiniFlawlessMechanicsSteppable where Self: UIColor  {
    
    public var length: Double {
        let v = getHSB
        return sqrt(v.h * v.h + v.s * v.s + v.b * v.b + v.a * v.a)
    }
    
    public func distance(toSegment segment: (from: Self, to: Self)) -> Double {
        
        let o = getHSB
        let v = segment.0.getHSB
        let w = segment.1.getHSB
    
        let pv_dh = o.h - v.h
        let pv_ds = o.s - v.s
        let pv_db = o.b - v.b
        let pv_da = o.a - v.a
        
        let wv_dh = w.h - v.h
        let wv_ds = w.s - v.s
        let wv_db = w.b - v.b
        let wv_da = w.a - v.a

        let dot = pv_dh * wv_dh + pv_ds * wv_ds + pv_db * wv_db + pv_da * wv_da
        let len_sq = wv_dh * wv_dh + wv_ds * wv_ds + wv_db * wv_db + wv_da * wv_da
        let param = dot / len_sq

        var int_h, int_s, int_b, int_a: Double /* intersection of normal to vw that goes through p */

        if param < 0 || (v.h == w.h && v.s == w.s && v.b == w.b && v.a == w.a) {
            int_h = v.h
            int_s = v.s
            int_b = v.b
            int_a = v.a
        } else if param > 1 {
            int_h = w.h
            int_s = w.s
            int_b = w.b
            int_a = w.a
        } else {
            int_h = v.h + param * wv_dh
            int_s = v.s + param * wv_ds
            int_b = v.b + param * wv_db
            int_a = v.a + param * wv_da
        }

        /* Components of normal */
        let dh = o.h - int_h
        let ds = o.s - int_s
        let db = o.b - int_b
        let da = o.a - int_a

        return sqrt(dh * dh + ds * ds + db * db + da * da)
    }
    
}

extension UIColor: MiniFlawlessSteppable {  }
extension UIColor: MiniFlawlessMechanicsSteppable {  }


extension CGColor {
    
    fileprivate var getHSB: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1
        
        UIColor.init(cgColor: self).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return (h, s, b, a)
    }
    
}

extension MiniFlawlessSteppable where Self: CGColor {
    
    private static func clamp(_ value: CGFloat) -> CGFloat {
        min(max(value, 0), 1.0)
    }
    
    public static var isClampable: Bool { true }
    
    public static var zero: Self {
        zeroValue()
    }
    
    public var elements: Distance {
        let result = getHSB
        return [
            .init(result.h), .init(result.s),
            .init(result.b), .init(result.a)
        ]
    }
    
    public static prefix func --- (value: Self) -> Self {
        let v = value.getHSB
        
        let result = UIColor.init(
            hue: 1.0 - v.h,
            saturation: 1.0 - v.s,
            brightness: 1.0 - v.b,
            alpha: 1.0 - v.a
        ).cgColor
        
        return (result as? Self) ?? zeroValue()
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Self {
        let lHSB = lhs.getHSB
        let rHSB = rhs.getHSB

        let result = UIColor.init(
            hue:        clamp(lHSB.h - rHSB.h),
            saturation: clamp(lHSB.s - rHSB.s),
            brightness: clamp(lHSB.b - rHSB.b),
            alpha:      clamp(lHSB.a - rHSB.a)
        ).cgColor
        
        return (result as? Self) ?? zeroValue()
    }
    
    public static func ---> (lhs: Self, rhs: Self) -> Distance {
        let lHSB = lhs.getHSB
        let rHSB = rhs.getHSB

        return [
            .init(lHSB.h - rHSB.h),
            .init(lHSB.s - rHSB.s),
            .init(lHSB.b - rHSB.b),
            .init(lHSB.a - rHSB.a)
        ]
    }
    
    
    public static func --+ (lhs: Self, rhs: Self) -> Self {
        let lHSB = lhs.getHSB
        let rHSB = rhs.getHSB

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
                hue:        clamp(CGFloat(lhs[0])),
                saturation: clamp(CGFloat(lhs[1])),
                brightness: clamp(CGFloat(lhs[2])),
                alpha:      clamp(CGFloat(lhs[3]))
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
        let rHSB = rhs.getHSB

        let result = UIColor.init(
            hue:        clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.h) ?? 0),
            saturation: clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.s) ?? 0),
            brightness: clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.b) ?? 0),
            alpha:      clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.a) ?? 0)
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
        let rHSB = rhs.getHSB

        let result = UIColor.init(
            hue:        clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.h) ?? 0),
            saturation: clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.s) ?? 0),
            brightness: clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.b) ?? 0),
            alpha:      clamp(CGFloat(exactly: CGFloat(lhs) * rHSB.a) ?? 0)
        ).cgColor
        
        return (result as? Self) ?? zeroValue()
    }
    
    
    public static func --/ <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        let rHSB = rhs.getHSB

        let result = UIColor.init(
            hue:        clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.h) ?? 0),
            saturation: clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.s) ?? 0),
            brightness: clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.b) ?? 0),
            alpha:      clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.a) ?? 0)
        ).cgColor
        
        return (result as? Self) ?? zeroValue()
    }
    
    public static func --/ <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        let lHSB = lhs.getHSB

        let result = UIColor.init(
            hue:        clamp(CGFloat(exactly: lHSB.h / CGFloat(rhs)) ?? 0),
            saturation: clamp(CGFloat(exactly: lHSB.s / CGFloat(rhs)) ?? 0),
            brightness: clamp(CGFloat(exactly: lHSB.b / CGFloat(rhs)) ?? 0),
            alpha:      clamp(CGFloat(exactly: lHSB.a / CGFloat(rhs)) ?? 0)
        ).cgColor
        
        return (result as? Self) ?? zeroValue()
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        let rHSB = rhs.getHSB

        let result = UIColor.init(
            hue:        clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.h) ?? 0),
            saturation: clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.s) ?? 0),
            brightness: clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.b) ?? 0),
            alpha:      clamp(CGFloat(exactly: CGFloat(lhs) / rHSB.a) ?? 0)
        ).cgColor
        
        return (result as? Self) ?? zeroValue()
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        let lHSB = lhs.getHSB

        let result = UIColor.init(
            hue:        clamp(CGFloat(exactly: lHSB.h / CGFloat(rhs)) ?? 0),
            saturation: clamp(CGFloat(exactly: lHSB.s / CGFloat(rhs)) ?? 0),
            brightness: clamp(CGFloat(exactly: lHSB.b / CGFloat(rhs)) ?? 0),
            alpha:      clamp(CGFloat(exactly: lHSB.a / CGFloat(rhs)) ?? 0)
        ).cgColor
        
        return (result as? Self) ?? zeroValue()
    }
    
    
    private static func zeroValue() -> Self {
        UIColor.black.cgColor as! Self
    }
    
}

extension MiniFlawlessMechanicsSteppable where Self: CGColor  {
    
    public var length: Double {
        let v = getHSB
        return sqrt(v.h * v.h + v.s * v.s + v.b * v.b + v.a * v.a)
    }
    
    public func distance(toSegment segment: (from: Self, to: Self)) -> Double {
        
        let o = getHSB
        let v = segment.0.getHSB
        let w = segment.1.getHSB
    
        let pv_dh = o.h - v.h
        let pv_ds = o.s - v.s
        let pv_db = o.b - v.b
        let pv_da = o.a - v.a
        
        let wv_dh = w.h - v.h
        let wv_ds = w.s - v.s
        let wv_db = w.b - v.b
        let wv_da = w.a - v.a

        let dot = pv_dh * wv_dh + pv_ds * wv_ds + pv_db * wv_db + pv_da * wv_da
        let len_sq = wv_dh * wv_dh + wv_ds * wv_ds + wv_db * wv_db + wv_da * wv_da
        let param = dot / len_sq

        var int_h, int_s, int_b, int_a: Double /* intersection of normal to vw that goes through p */

        if param < 0 || (v.h == w.h && v.s == w.s && v.b == w.b && v.a == w.a) {
            int_h = v.h
            int_s = v.s
            int_b = v.b
            int_a = v.a
        } else if param > 1 {
            int_h = w.h
            int_s = w.s
            int_b = w.b
            int_a = w.a
        } else {
            int_h = v.h + param * wv_dh
            int_s = v.s + param * wv_ds
            int_b = v.b + param * wv_db
            int_a = v.a + param * wv_da
        }

        /* Components of normal */
        let dh = o.h - int_h
        let ds = o.s - int_s
        let db = o.b - int_b
        let da = o.a - int_a

        return sqrt(dh * dh + ds * ds + db * db + da * da)
    }
    
}

extension CGColor: MiniFlawlessSteppable {  }
extension CGColor: MiniFlawlessMechanicsSteppable {  }


extension MiniFlawlessSteppable where Self: CIColor {
    
    private static func clamp(_ value: CGFloat) -> CGFloat {
        min(max(value, 0), 1.0)
    }
    
    public static var isClampable: Bool { true }
    
    public static var zero: Self {
        zeroValue()
    }
    
    public var elements: Distance {
        return [
            .init(red), .init(green),
            .init(blue), .init(alpha)
        ]
    }
    
    public static prefix func --- (value: Self) -> Self {
        .init(
            red:   1 - value.red,
            green: 1 - value.green,
            blue:  1 - value.blue,
            alpha: 1 - value.alpha
        )
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Self {
        .init(
            red:   clamp(lhs.red   - rhs.red),
            green: clamp(lhs.green - rhs.green),
            blue:  clamp(lhs.blue  - rhs.blue),
            alpha: clamp(lhs.alpha - rhs.alpha)
        )
    }
    
    public static func ---> (lhs: Self, rhs: Self) -> Distance {
        [
            .init(lhs.red   - rhs.red),
            .init(lhs.green - rhs.green),
            .init(lhs.blue  - rhs.blue),
            .init(lhs.alpha - rhs.alpha)
        ]
    }
    
    
    public static func --+ (lhs: Self, rhs: Self) -> Self {
        .init(
            red:   clamp(lhs.red + rhs.red),
            green: clamp(lhs.green + rhs.green),
            blue:  clamp(lhs.blue + rhs.blue),
            alpha: clamp(lhs.alpha + rhs.alpha)
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
        return (
            .init(
                red:   clamp(CGFloat(lhs[0])),
                green: clamp(CGFloat(lhs[1])),
                blue:  clamp(CGFloat(lhs[2])),
                alpha: clamp(CGFloat(lhs[3]))
            )
        ) --+ rhs
    }
    
    
    public static func --* <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(
            red:   clamp(CGFloat(exactly: CGFloat(lhs) * rhs.red) ?? 0),
            green: clamp(CGFloat(exactly: CGFloat(lhs) * rhs.green) ?? 0),
            blue:  clamp(CGFloat(exactly: CGFloat(lhs) * rhs.blue) ?? 0),
            alpha: clamp(CGFloat(exactly: CGFloat(lhs) * rhs.alpha) ?? 0)
        )
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        .init(
            red:   clamp(CGFloat(exactly: CGFloat(lhs) * rhs.red) ?? 0),
            green: clamp(CGFloat(exactly: CGFloat(lhs) * rhs.green) ?? 0),
            blue:  clamp(CGFloat(exactly: CGFloat(lhs) * rhs.blue) ?? 0),
            alpha: clamp(CGFloat(exactly: CGFloat(lhs) * rhs.alpha) ?? 0)
        )
    }
    
    
    public static func --/ <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(
            red:   clamp(CGFloat(exactly: CGFloat(lhs) / rhs.red) ?? 0),
            green: clamp(CGFloat(exactly: CGFloat(lhs) / rhs.green) ?? 0),
            blue:  clamp(CGFloat(exactly: CGFloat(lhs) / rhs.blue) ?? 0),
            alpha: clamp(CGFloat(exactly: CGFloat(lhs) / rhs.alpha) ?? 0)
        )
    }
    
    public static func --/ <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        .init(
            red:   clamp(CGFloat(exactly: lhs.red   / CGFloat(rhs)) ?? 0),
            green: clamp(CGFloat(exactly: lhs.green / CGFloat(rhs)) ?? 0),
            blue:  clamp(CGFloat(exactly: lhs.blue  / CGFloat(rhs)) ?? 0),
            alpha: clamp(CGFloat(exactly: lhs.alpha / CGFloat(rhs)) ?? 0)
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        .init(
            red:   clamp(CGFloat(exactly: CGFloat(lhs) / rhs.red) ?? 0),
            green: clamp(CGFloat(exactly: CGFloat(lhs) / rhs.green) ?? 0),
            blue:  clamp(CGFloat(exactly: CGFloat(lhs) / rhs.blue) ?? 0),
            alpha: clamp(CGFloat(exactly: CGFloat(lhs) / rhs.alpha) ?? 0)
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        .init(
            red:   clamp(CGFloat(exactly: lhs.red   / CGFloat(rhs)) ?? 0),
            green: clamp(CGFloat(exactly: lhs.green / CGFloat(rhs)) ?? 0),
            blue:  clamp(CGFloat(exactly: lhs.blue  / CGFloat(rhs)) ?? 0),
            alpha: clamp(CGFloat(exactly: lhs.alpha / CGFloat(rhs)) ?? 0)
        )
    }
    
    
    private static func zeroValue() -> Self {
        UIColor.black.ciColor as! Self
    }
    
}

extension MiniFlawlessMechanicsSteppable where Self: CIColor  {
    
    public var length: Double {
        sqrt(red * red + green * green + blue * blue + alpha * alpha)
    }
    
    public func distance(toSegment segment: (from: Self, to: Self)) -> Double {
        
        let o = self
        let v = segment.0
        let w = segment.1
    
        let pv_dred = o.red - v.red
        let pv_dgreen = o.green - v.green
        let pv_dblue = o.blue - v.blue
        let pv_dalpha = o.alpha - v.alpha
        
        let wv_dred = w.red - v.red
        let wv_dgreen = w.green - v.green
        let wv_dblue = w.blue - v.blue
        let wv_dalpha = w.alpha - v.alpha

        let dot = pv_dred * wv_dred + pv_dgreen * wv_dgreen + pv_dblue * wv_dblue + pv_dalpha * wv_dalpha
        let len_sq = wv_dred * wv_dred + wv_dgreen * wv_dgreen + wv_dblue * wv_dblue + wv_dalpha * wv_dalpha
        let param = dot / len_sq

        var int_red, int_green, int_blue, int_alpha: Double /* intersection of normal to vw that goes through p */

        if param < 0 || (v.red == w.red && v.green == w.green && v.blue == w.blue && v.alpha == w.alpha) {
            int_red = v.red
            int_green = v.green
            int_blue = v.blue
            int_alpha = v.alpha
        } else if param > 1 {
            int_red = w.red
            int_green = w.green
            int_blue = w.blue
            int_alpha = w.alpha
        } else {
            int_red = v.red + param * wv_dred
            int_green = v.green + param * wv_dgreen
            int_blue = v.blue + param * wv_dblue
            int_alpha = v.alpha + param * wv_dalpha
        }

        /* Components of normal */
        let dred = o.red - int_red
        let dgreen = o.green - int_green
        let dblue = o.blue - int_blue
        let dalpha = o.alpha - int_alpha

        return sqrt(dred * dred + dgreen * dgreen + dblue * dblue + dalpha * dalpha)
    }
    
}

extension CIColor: MiniFlawlessSteppable {  }
extension CIColor: MiniFlawlessMechanicsSteppable {  }
