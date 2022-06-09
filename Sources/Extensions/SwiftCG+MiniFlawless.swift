//
//  SwiftBase+MiniFlawless.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/3.
//

import UIKit

extension CGFloat: MiniFlawlessSteppable {
    
    public static var isClampable: Bool { false }
    
    public var elements: Distance { [.init(self)] }
    
    public static prefix func --- (value: Self) -> Self {
        -value
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

extension CGFloat: MiniFlawlessMechanicsSteppable {
    
    public var length: Double {
        .init(self)
    }
    
    public func distance(toSegment segment: (from: Self, to: Self)) -> Double {
        let l = abs(self - segment.from)
        let r = abs(self - segment.to)
        return Swift.min(Double(l), Double(r))
    }
    
}


extension CGPoint: MiniFlawlessSteppable {
    
    public static var isClampable: Bool { false }
    
    public var elements: Distance { [.init(x), .init(y)] }
    
    public static prefix func --- (value: Self) -> Self {
        .init(x: -value.x, y: -value.y)
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Self {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public static func ---> (lhs: Self, rhs: Self) -> Distance {
        [ .init(lhs.x - rhs.x), .init(lhs.y - rhs.y) ]
    }
    
    
    public static func --+ (lhs: Self, rhs: Self) -> Self {
        .init(
            x: lhs.x + rhs.x, y: lhs.y + rhs.y
        )
    }
    
    public static func --+ (lhs: Distance, rhs: Self) -> Self {
        distanceAdd(lhs: lhs, rhs: rhs)
    }
    
    public static func --+ (lhs: Self, rhs: Distance) -> Self {
        distanceAdd(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceAdd(lhs: Distance, rhs: Self) -> Self {
        guard lhs.count >= 2 else { return rhs }
        return CGPoint(x: CGFloat(lhs[0]), y: CGFloat(lhs[1])) --+ rhs
    }
    
    
    public static func --* <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(
            x: CGFloat(exactly: CGFloat(lhs) * rhs.x) ?? 0,
            y: CGFloat(exactly: CGFloat(lhs) * rhs.y) ?? 0
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
            x: CGFloat(exactly: CGFloat(lhs) * rhs.x) ?? 0,
            y: CGFloat(exactly: CGFloat(lhs) * rhs.y) ?? 0
        )
    }
    
    
    public static func --/ <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(
            x: CGFloat(exactly: CGFloat(lhs) / rhs.x) ?? 0,
            y: CGFloat(exactly: CGFloat(lhs) / rhs.y) ?? 0
        )
    }
    
    public static func --/ <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        .init(
            x: CGFloat(exactly: lhs.x / CGFloat(rhs)) ?? 0,
            y: CGFloat(exactly: lhs.y / CGFloat(rhs)) ?? 0
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        .init(
            x: CGFloat(exactly: CGFloat(lhs) / rhs.x) ?? 0,
            y: CGFloat(exactly: CGFloat(lhs) / rhs.y) ?? 0
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        .init(
            x: CGFloat(exactly: lhs.x / CGFloat(rhs)) ?? 0,
            y: CGFloat(exactly: lhs.y / CGFloat(rhs)) ?? 0
        )
    }
    
}

extension CGPoint: MiniFlawlessMechanicsSteppable {
    
    public var length: Double {
        sqrt(x * x + y * y)
    }
    
    public func distance(toSegment segment: (from: Self, to: Self)) -> Double {
        let v = segment.0
        let w = segment.1
    
        let pv_dx = x - v.x
        let pv_dy = y - v.y
        let wv_dx = w.x - v.x
        let wv_dy = w.y - v.y

        let dot = pv_dx * wv_dx + pv_dy * wv_dy
        let len_sq = wv_dx * wv_dx + wv_dy * wv_dy
        let param = dot / len_sq

        var int_x, int_y: Double /* intersection of normal to vw that goes through p */

        if param < 0 || (v.x == w.x && v.y == w.y) {
            int_x = v.x
            int_y = v.y
        } else if param > 1 {
            int_x = w.x
            int_y = w.y
        } else {
            int_x = v.x + param * wv_dx
            int_y = v.y + param * wv_dy
        }

        /* Components of normal */
        let dx = x - int_x
        let dy = y - int_y

        return sqrt(dx * dx + dy * dy)
    }
    
}

extension CGSize: MiniFlawlessSteppable {
    
    public static var isClampable: Bool { false }
    
    public var elements: Distance { [.init(width), .init(height)] }
    
    public static prefix func --- (value: Self) -> Self {
        .init(width: -value.width, height: -value.height)
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Self {
        .init(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
    
    public static func ---> (lhs: Self, rhs: Self) -> Distance {
        [
            .init(lhs.width - rhs.width),
            .init(lhs.height - rhs.height)
        ]
    }
    
    
    public static func --+ (lhs: Self, rhs: Self) -> Self {
        .init(
            width:  lhs.width  + rhs.width,
            height: lhs.height + rhs.height
        )
    }
    
    public static func --+ (lhs: Distance, rhs: Self) -> Self {
        distanceAdd(lhs: lhs, rhs: rhs)
    }
    
    public static func --+ (lhs: Self, rhs: Distance) -> Self {
        distanceAdd(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceAdd(lhs: Distance, rhs: Self) -> Self {
        guard lhs.count >= 2 else { return rhs }
        return CGSize(width: lhs[0], height: lhs[1]) --+ rhs
    }
    
    
    public static func --* <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(
            width:  CGFloat(exactly: CGFloat(lhs) * rhs.width) ?? 0,
            height: CGFloat(exactly: CGFloat(lhs) * rhs.height) ?? 0
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
            width:  CGFloat(exactly: CGFloat(lhs) * rhs.width) ?? 0,
            height: CGFloat(exactly: CGFloat(lhs) * rhs.height) ?? 0
        )
    }
    
    
    
    public static func --/ <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(
            width:  CGFloat(exactly: CGFloat(lhs) / rhs.width) ?? 0,
            height: CGFloat(exactly: CGFloat(lhs) / rhs.height) ?? 0
        )
    }
    
    public static func --/ <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        .init(
            width:  CGFloat(exactly: lhs.width  / CGFloat(rhs)) ?? 0,
            height: CGFloat(exactly: lhs.height / CGFloat(rhs)) ?? 0
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        .init(
            width:  CGFloat(exactly: CGFloat(lhs) / rhs.width) ?? 0,
            height: CGFloat(exactly: CGFloat(lhs) / rhs.height) ?? 0
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        .init(
            width:  CGFloat(exactly: lhs.width  / CGFloat(rhs)) ?? 0,
            height: CGFloat(exactly: lhs.height / CGFloat(rhs)) ?? 0
        )
    }
    
}

extension CGSize: MiniFlawlessMechanicsSteppable {
    
    private var x: CGFloat { width }
    private var y: CGFloat { height }
    
    public var length: Double {
        sqrt(x * x + y * y)
    }
    
    public func distance(toSegment segment: (from: Self, to: Self)) -> Double {
        let v = segment.0
        let w = segment.1
    
        let pv_dx = x - v.x
        let pv_dy = y - v.y
        let wv_dx = w.x - v.x
        let wv_dy = w.y - v.y

        let dot = pv_dx * wv_dx + pv_dy * wv_dy
        let len_sq = wv_dx * wv_dx + wv_dy * wv_dy
        let param = dot / len_sq

        var int_x, int_y: Double /* intersection of normal to vw that goes through p */

        if param < 0 || (v.x == w.x && v.y == w.y) {
            int_x = v.x
            int_y = v.y
        } else if param > 1 {
            int_x = w.x
            int_y = w.y
        } else {
            int_x = v.x + param * wv_dx
            int_y = v.y + param * wv_dy
        }

        /* Components of normal */
        let dx = x - int_x
        let dy = y - int_y

        return sqrt(dx * dx + dy * dy)
    }
    
}


extension CGRect: MiniFlawlessSteppable {
    
    public static var isClampable: Bool { false }
    
    public var elements: Distance {
        [ .init(origin.x), .init(origin.y), .init(width), .init(height) ]
    }
    
    public static prefix func --- (value: Self) -> Self {
        .init(x: -value.origin.x, y: -value.origin.y, width: -value.width, height: -value.height)
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Self {
        let ls = lhs.elements
        let rs = rhs.elements
        return .init(
            x: ls[0] - rs[0],
            y: ls[1] - rs[1],
            width: ls[2] - rs[2],
            height: ls[3] - rs[3]
        )
    }
    
    public static func ---> (lhs: Self, rhs: Self) -> Distance {
        let ls = lhs.elements
        let rs = rhs.elements
        return [
            ls[0] - rs[0],
            ls[1] - rs[1],
            ls[2] - rs[2],
            ls[3] - rs[3]
        ]
    }
    
    
    public static func --+ (lhs: Self, rhs: Self) -> Self {
        .init(
            origin: lhs.origin --+ rhs.origin,
            size:   lhs.size --+ rhs.size
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
            origin: CGPoint(x: CGFloat(lhs[0]), y: CGFloat(lhs[1])) --+ rhs.origin,
            size:   CGSize(width: CGFloat(lhs[2]), height: CGFloat(lhs[3])) --+ rhs.size
        )
    }
    
    
    public static func --* <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(
            origin: lhs --* rhs.origin,
            size:   lhs --* rhs.size
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
            origin: lhs --* rhs.origin,
            size:   lhs --* rhs.size
        )
    }
    
    
    public static func --/ <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(
            origin: lhs --/ rhs.origin,
            size:   lhs --/ rhs.size
        )
    }
    
    public static func --/ <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        .init(
            origin: lhs.origin --/ rhs,
            size:   lhs.size   --/ rhs
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        .init(
            origin: lhs --/ rhs.origin,
            size:   lhs --/ rhs.size
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        .init(
            origin: lhs.origin --/ rhs,
            size:   lhs.size   --/ rhs
        )
    }
    
}

extension CGRect: MiniFlawlessMechanicsSteppable {
    
    private var x: CGFloat { origin.x }
    private var y: CGFloat { origin.y }
    private var w: CGFloat { width }
    private var h: CGFloat { height }
    
    public var length: Double {
        sqrt(x * x + y * y + w * w + h * h)
    }
    
    public func distance(toSegment segment: (from: Self, to: Self)) -> Double {
        let v = segment.0
        let w = segment.1
    
        let pv_dx = x - v.x
        let pv_dy = y - v.y
        let pv_dw = self.w - v.w
        let pv_dh = h - v.h
        
        let wv_dx = w.x - v.x
        let wv_dy = w.y - v.y
        let wv_dw = w.w - v.w
        let wv_dh = w.h - v.h

        let dot = pv_dx * wv_dx + pv_dy * wv_dy + pv_dw * wv_dw + pv_dh * wv_dh
        let len_sq = wv_dx * wv_dx + wv_dy * wv_dy + wv_dw * wv_dw + wv_dh * wv_dh
        let param = dot / len_sq

        var int_x, int_y, int_w, int_h: Double /* intersection of normal to vw that goes through p */

        if param < 0 || (v.x == w.x && v.y == w.y && v.w == w.w && v.h == w.h) {
            int_x = v.x
            int_y = v.y
            int_w = v.w
            int_h = v.h
        } else if param > 1 {
            int_x = w.x
            int_y = w.y
            int_w = w.w
            int_h = w.h
        } else {
            int_x = v.x + param * wv_dx
            int_y = v.y + param * wv_dy
            int_w = v.w + param * wv_dw
            int_h = v.h + param * wv_dh
        }

        /* Components of normal */
        let dx = x - int_x
        let dy = y - int_y
        let dw = self.w - int_w
        let dh = h - int_h

        return sqrt(dx * dx + dy * dy + dw * dw + dh * dh)
    }
    
}


extension UIEdgeInsets: MiniFlawlessSteppable {
    
    public static var isClampable: Bool { false }
    
    public var elements: Distance {
        [ .init(top), .init(left), .init(bottom), .init(right) ]
    }
    
    public static prefix func --- (value: Self) -> Self {
        .init(top: -value.top, left: -value.left, bottom: -value.right, right: -value.bottom)
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Self {
        .init(
            top:    CGFloat(lhs.top    - rhs.top   ),
            left:   CGFloat(lhs.left   - rhs.left  ),
            bottom: CGFloat(lhs.bottom - rhs.bottom),
            right:  CGFloat(lhs.right  - rhs.right )
        )
    }
    
    public static func ---> (lhs: Self, rhs: Self) -> Distance {
        [
            CGFloat(lhs.top    - rhs.top   ),
            CGFloat(lhs.left   - rhs.left  ),
            CGFloat(lhs.bottom - rhs.bottom),
            CGFloat(lhs.right  - rhs.right )
        ]
    }
    
    
    public static func --+ (lhs: Self, rhs: Self) -> Self {
        .init(
            top:    lhs.top    + rhs.top,
            left:   lhs.left   + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right:  lhs.right  + rhs.right
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
            top:    CGFloat(lhs[0]),
            left:   CGFloat(lhs[1]),
            bottom: CGFloat(lhs[2]),
            right:  CGFloat(lhs[3])
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
            top:    CGFloat(exactly: CGFloat(lhs) * rhs.top) ?? 0,
            left:   CGFloat(exactly: CGFloat(lhs) * rhs.left) ?? 0,
            bottom: CGFloat(exactly: CGFloat(lhs) * rhs.bottom) ?? 0,
            right:  CGFloat(exactly: CGFloat(lhs) * rhs.right) ?? 0
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
            top:    CGFloat(exactly: CGFloat(lhs) * rhs.top) ?? 0,
            left:   CGFloat(exactly: CGFloat(lhs) * rhs.left) ?? 0,
            bottom: CGFloat(exactly: CGFloat(lhs) * rhs.bottom) ?? 0,
            right:  CGFloat(exactly: CGFloat(lhs) * rhs.right) ?? 0
        )
    }
    
    
    public static func --/ <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(
            top:    CGFloat(exactly: CGFloat(lhs) / rhs.top) ?? 0,
            left:   CGFloat(exactly: CGFloat(lhs) / rhs.left) ?? 0,
            bottom: CGFloat(exactly: CGFloat(lhs) / rhs.bottom) ?? 0,
            right:  CGFloat(exactly: CGFloat(lhs) / rhs.right) ?? 0
        )
    }
    
    public static func --/ <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        .init(
            top:    CGFloat(exactly: lhs.top    / CGFloat(rhs)) ?? 0,
            left:   CGFloat(exactly: lhs.left   / CGFloat(rhs)) ?? 0,
            bottom: CGFloat(exactly: lhs.bottom / CGFloat(rhs)) ?? 0,
            right:  CGFloat(exactly: lhs.right  / CGFloat(rhs)) ?? 0
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        .init(
            top:    CGFloat(exactly: CGFloat(lhs) / rhs.top) ?? 0,
            left:   CGFloat(exactly: CGFloat(lhs) / rhs.left) ?? 0,
            bottom: CGFloat(exactly: CGFloat(lhs) / rhs.bottom) ?? 0,
            right:  CGFloat(exactly: CGFloat(lhs) / rhs.right) ?? 0
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        .init(
            top:    CGFloat(exactly: lhs.top    / CGFloat(rhs)) ?? 0,
            left:   CGFloat(exactly: lhs.left   / CGFloat(rhs)) ?? 0,
            bottom: CGFloat(exactly: lhs.bottom / CGFloat(rhs)) ?? 0,
            right:  CGFloat(exactly: lhs.right  / CGFloat(rhs)) ?? 0
        )
    }
    
}

extension UIEdgeInsets: MiniFlawlessMechanicsSteppable {
    
    private var t: CGFloat { top }
    private var l: CGFloat { left }
    private var b: CGFloat { bottom }
    private var r: CGFloat { right }
    
    public var length: Double {
        sqrt(t * t + l * l + b * b + r * r)
    }
    
    public func distance(toSegment segment: (from: Self, to: Self)) -> Double {
        let v = segment.0
        let w = segment.1
    
        let pv_dt = t - v.t
        let pv_dl = l - v.l
        let pv_db = b - v.b
        let pv_dr = r - v.r
        
        let wv_dt = w.t - v.t
        let wv_dl = w.l - v.l
        let wv_db = w.b - v.b
        let wv_dr = w.r - v.r

        let dot = pv_dt * wv_dt + pv_dl * wv_dl + pv_db * wv_db + pv_dr * wv_dr
        let len_sq = wv_dt * wv_dt + wv_dl * wv_dl + wv_db * wv_db + wv_dr * wv_dr
        let param = dot / len_sq

        var int_t, int_l, int_b, int_r: Double /* intersection of normal to vw that goes through p */

        if param < 0 || (v.t == w.t && v.l == w.l && v.b == w.b && v.r == w.r) {
            int_t = v.t
            int_l = v.l
            int_b = v.b
            int_r = v.r
        } else if param > 1 {
            int_t = w.t
            int_l = w.l
            int_b = w.b
            int_r = w.r
        } else {
            int_t = v.t + param * wv_dt
            int_l = v.l + param * wv_dl
            int_b = v.b + param * wv_db
            int_r = v.r + param * wv_dr
        }

        /* Components of normal */
        let dt = t - int_t
        let dl = l - int_l
        let db = b - int_b
        let dr = r - int_r

        return sqrt(dt * dt + dl * dl + db * db + dr * dr)
    }
    
}


#if os(macOS)
extension NSEdgeInsets: MiniFlawlessSteppable {
    
    public static var isClampable: Bool { false }
    
    public var elements: Distance {
        [ .init(top), .init(left), .init(bottom), .init(right) ]
    }
    
    public static prefix func --- (value: Self) -> Self {
        .init(left: -value.left, top: -value.top, right: -value.right, bottom: -value.bottom)
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Self {
        .init(
            left:   CGFloat(lhs.left   - rhs.left  ),
            top:    CGFloat(lhs.top    - rhs.top   ),
            right:  CGFloat(lhs.right  - rhs.right ),
            bottom: CGFloat(lhs.bottom - rhs.bottom)
        )
    }
    
    public static func ---> (lhs: Self, rhs: Self) -> Distance {
        [
            CGFloat(lhs.top    - rhs.top   ),
            CGFloat(lhs.left   - rhs.left  ),
            CGFloat(lhs.bottom - rhs.bottom),
            CGFloat(lhs.right  - rhs.right )
        ]
    }
    
    
    public static func --+ (lhs: Self, rhs: Self) -> Self {
        .init(
            top:    lhs.top    + rhs.top,
            left:   lhs.left   + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right:  lhs.right  + rhs.right
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
            top:    CGFloat(lhs[0]),
            left:   CGFloat(lhs[1]),
            bottom: CGFloat(lhs[2]),
            right:  CGFloat(lhs[3])
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
            top:    CGFloat(exactly: CGFloat(lhs) * rhs.top) ?? 0,
            left:   CGFloat(exactly: CGFloat(lhs) * rhs.left) ?? 0,
            bottom: CGFloat(exactly: CGFloat(lhs) * rhs.bottom) ?? 0,
            right:  CGFloat(exactly: CGFloat(lhs) * rhs.right) ?? 0
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
            top:    CGFloat(exactly: CGFloat(lhs) * rhs.top) ?? 0,
            left:   CGFloat(exactly: CGFloat(lhs) * rhs.left) ?? 0,
            bottom: CGFloat(exactly: CGFloat(lhs) * rhs.bottom) ?? 0,
            right:  CGFloat(exactly: CGFloat(lhs) * rhs.right) ?? 0
        )
    }
    
    
    public static func --/ <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(
            top:    CGFloat(exactly: CGFloat(lhs) / rhs.top) ?? 0,
            left:   CGFloat(exactly: CGFloat(lhs) / rhs.left) ?? 0,
            bottom: CGFloat(exactly: CGFloat(lhs) / rhs.bottom) ?? 0,
            right:  CGFloat(exactly: CGFloat(lhs) / rhs.right) ?? 0
        )
    }
    
    public static func --/ <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        .init(
            top:    CGFloat(exactly: lhs.top    / CGFloat(rhs)) ?? 0,
            left:   CGFloat(exactly: lhs.left   / CGFloat(rhs)) ?? 0,
            bottom: CGFloat(exactly: lhs.bottom / CGFloat(rhs)) ?? 0,
            right:  CGFloat(exactly: lhs.right  / CGFloat(rhs)) ?? 0
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        .init(
            top:    CGFloat(exactly: CGFloat(lhs) / rhs.top) ?? 0,
            left:   CGFloat(exactly: CGFloat(lhs) / rhs.left) ?? 0,
            bottom: CGFloat(exactly: CGFloat(lhs) / rhs.bottom) ?? 0,
            right:  CGFloat(exactly: CGFloat(lhs) / rhs.right) ?? 0
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        .init(
            top:    CGFloat(exactly: lhs.top    / CGFloat(rhs)) ?? 0,
            left:   CGFloat(exactly: lhs.left   / CGFloat(rhs)) ?? 0,
            bottom: CGFloat(exactly: lhs.bottom / CGFloat(rhs)) ?? 0,
            right:  CGFloat(exactly: lhs.right  / CGFloat(rhs)) ?? 0
        )
    }
    
}

extension NSEdgeInsets: MiniFlawlessMechanicsSteppable {
    
    private var t: CGFloat { top }
    private var l: CGFloat { left }
    private var b: CGFloat { bottom }
    private var r: CGFloat { right }
    
    public var length: Double {
        sqrt(t * t + l * l + b * b + r * r)
    }
    
    public func distance(toSegment segment: (from: Self, to: Self)) -> Double {
        let v = segment.0
        let w = segment.1
    
        let pv_dt = t - v.t
        let pv_dl = l - v.l
        let pv_db = b - v.b
        let pv_dr = r - v.r
        
        let wv_dt = w.t - v.t
        let wv_dl = w.l - v.l
        let wv_db = w.b - v.b
        let wv_dr = w.r - v.r

        let dot = pv_dt * wv_dt + pv_dl * wv_dl + pv_db * wv_db + pv_dr * wv_dr
        let len_sq = wv_dt * wv_dt + wv_dl * wv_dl + wv_db * wv_db + wv_dr * wv_dr
        let param = dot / len_sq

        var int_t, int_l, int_b, int_r: Double /* intersection of normal to vw that goes through p */

        if param < 0 || (v.t == w.t && v.l == w.l && v.b == w.b && v.r == w.r) {
            int_t = v.t
            int_l = v.l
            int_b = v.b
            int_r = v.r
        } else if param > 1 {
            int_t = w.t
            int_l = w.l
            int_b = w.b
            int_r = w.r
        } else {
            int_t = v.t + param * wv_dt
            int_l = v.l + param * wv_dl
            int_b = v.b + param * wv_db
            int_r = v.r + param * wv_dr
        }

        /* Components of normal */
        let dt = t - int_t
        let dl = l - int_l
        let db = b - int_b
        let dr = r - int_r

        return sqrt(dt * dt + dl * dl + db * db + dr * dr)
    }
    
}

#endif
