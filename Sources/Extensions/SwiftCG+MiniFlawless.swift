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
    
    public static func --- (lhs: Self, rhs: Self) -> Distance {
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
        return .init(lhs[0] + TimeInterval(rhs))
    }
    
    public static func --* <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(exactly: lhs * .init(rhs)) ?? 0
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        .init(exactly: lhs * .init(rhs)) ?? 0
    }
    
}

extension CGPoint: MiniFlawlessSteppable {
    
    public static var isClampable: Bool { false }
    
    public var elements: Distance { [.init(x), .init(y)] }
    
    public static func --- (lhs: Self, rhs: Self) -> Distance {
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
        return .init(x: lhs[0], y: lhs[1]) --+ rhs
    }
    
    public static func --* <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(
            x: .init(exactly: .init(lhs) * rhs.x) ?? 0,
            y: .init(exactly: .init(lhs) * rhs.y) ?? 0
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
            x: .init(exactly: .init(lhs) * rhs.x) ?? 0,
            y: .init(exactly: .init(lhs) * rhs.y) ?? 0
        )
    }
    
}

extension CGSize: MiniFlawlessSteppable {
    
    public static var isClampable: Bool { false }
    
    public var elements: Distance { [.init(width), .init(height)] }
    
    public static func --- (lhs: Self, rhs: Self) -> Distance {
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
        
        return .init(width: lhs[0], height: lhs[1]) --+ rhs
    }
    
    public static func --* <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(
            width:  .init(exactly: lhs * .init(rhs.width)) ?? 0,
            height: .init(exactly: lhs * .init(rhs.height)) ?? 0
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
            width:  .init(exactly: lhs * .init(rhs.width)) ?? 0,
            height: .init(exactly: lhs * .init(rhs.height)) ?? 0
        )
    }
    
}

extension CGRect: MiniFlawlessSteppable {
    
    public static var isClampable: Bool { false }
    
    public var elements: Distance {
        [ .init(minX), .init(minY), .init(width), .init(height) ]
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Distance {
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
            origin: .init(x: lhs[0], y: lhs[1]) --+ rhs.origin,
            size:   .init(width: lhs[2], height: lhs[3]) --+ rhs.size
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
    
}

extension UIEdgeInsets: MiniFlawlessSteppable {
    
    public static var isClampable: Bool { false }
    
    public var elements: Distance {
        [ .init(top), .init(left), .init(bottom), .init(right) ]
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Distance {
        [
            .init(lhs.top    - rhs.top   ),
            .init(lhs.left   - rhs.left  ),
            .init(lhs.bottom - rhs.bottom),
            .init(lhs.right  - rhs.right )
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
            top:    .init(lhs[0]),
            left:   .init(lhs[1]),
            bottom: .init(lhs[2]),
            right:  .init(lhs[3])
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
            top:    .init(exactly: .init(lhs) * rhs.top) ?? 0,
            left:   .init(exactly: .init(lhs) * rhs.left) ?? 0,
            bottom: .init(exactly: .init(lhs) * rhs.bottom) ?? 0,
            right:  .init(exactly: .init(lhs) * rhs.right) ?? 0
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
            top:    .init(exactly: .init(lhs) * rhs.top) ?? 0,
            left:   .init(exactly: .init(lhs) * rhs.left) ?? 0,
            bottom: .init(exactly: .init(lhs) * rhs.bottom) ?? 0,
            right:  .init(exactly: .init(lhs) * rhs.right) ?? 0
        )
    }
    
}

#if os(macOS)
extension NSEdgeInsets: MiniFlawlessSteppable {
    
    public static var isClampable: Bool { false }
    
    public var elements: Distance {
        [ .init(top), .init(left), .init(bottom), .init(right) ]
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Distance {
        [
            .init(lhs.top    - rhs.top   ),
            .init(lhs.left   - rhs.left  ),
            .init(lhs.bottom - rhs.bottom),
            .init(lhs.right  - rhs.right )
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
            top:    .init(lhs[0]),
            left:   .init(lhs[1]),
            bottom: .init(lhs[2]),
            right:  .init(lhs[3])
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
            top:    .init(exactly: .init(lhs) * rhs.top) ?? 0,
            left:   .init(exactly: .init(lhs) * rhs.left) ?? 0,
            bottom: .init(exactly: .init(lhs) * rhs.bottom) ?? 0,
            right:  .init(exactly: .init(lhs) * rhs.right) ?? 0
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
            top:    .init(exactly: .init(lhs) * rhs.top) ?? 0,
            left:   .init(exactly: .init(lhs) * rhs.left) ?? 0,
            bottom: .init(exactly: .init(lhs) * rhs.bottom) ?? 0,
            right:  .init(exactly: .init(lhs) * rhs.right) ?? 0
        )
    }
    
}
#endif
