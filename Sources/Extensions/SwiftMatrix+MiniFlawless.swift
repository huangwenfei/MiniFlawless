//
//  SwiftMatrix+MiniFlawless.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/4.
//

import UIKit

extension CGAffineTransform: MiniFlawlessSteppable {
    
    public static var isClampable: Bool { false }
    
    public static var zero: Self {
        .identity
    }
    
    public var elements: Distance {
        [
            .init(a), .init(b), .init(c), .init(d),
            .init(tx), .init(ty)
        ]
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Distance {
        [
            .init(lhs.a  - rhs.a ), .init(lhs.b  - rhs.b ),
            .init(lhs.c  - rhs.c ), .init(lhs.d  - rhs.d ),
            .init(lhs.tx - rhs.tx), .init(lhs.ty - rhs.ty)
        ]
    }
    
    public static func --+ (lhs: Self, rhs: Self) -> Self {
        .init(
            a:  lhs.a  + rhs.a,
            b:  lhs.b  + rhs.b,
            c:  lhs.c  + rhs.c,
            d:  lhs.d  + rhs.d,
            tx: lhs.tx + rhs.tx,
            ty: lhs.ty + rhs.ty
        )
    }
    
    public static func --+ (lhs: Distance, rhs: Self) -> Self {
        distanceAdd(lhs: lhs, rhs: rhs)
    }
    
    public static func --+ (lhs: Self, rhs: Distance) -> Self {
        distanceAdd(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceAdd(lhs: Distance, rhs: Self) -> Self {
        guard lhs.count >= 6 else { return rhs }
        return .init(
            a:  .init(lhs[0]),
            b:  .init(lhs[0]),
            c:  .init(lhs[0]),
            d:  .init(lhs[0]),
            tx: .init(lhs[0]),
            ty: .init(lhs[0])
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
            a:  .init(exactly: .init(lhs) * rhs.a) ?? 0,
            b:  .init(exactly: .init(lhs) * rhs.b) ?? 0,
            c:  .init(exactly: .init(lhs) * rhs.c) ?? 0,
            d:  .init(exactly: .init(lhs) * rhs.d) ?? 0,
            tx: .init(exactly: .init(lhs) * rhs.tx) ?? 0,
            ty: .init(exactly: .init(lhs) * rhs.ty) ?? 0
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
            a:  .init(exactly: .init(lhs) * rhs.a) ?? 0,
            b:  .init(exactly: .init(lhs) * rhs.b) ?? 0,
            c:  .init(exactly: .init(lhs) * rhs.c) ?? 0,
            d:  .init(exactly: .init(lhs) * rhs.d) ?? 0,
            tx: .init(exactly: .init(lhs) * rhs.tx) ?? 0,
            ty: .init(exactly: .init(lhs) * rhs.ty) ?? 0
        )
    }
    
}

extension CATransform3D: MiniFlawlessSteppable {
    
    public static var isClampable: Bool { false }
    
    public static var zero: Self {
        .init(
            m11: 1, m12: 0, m13: 0, m14: 0,
            m21: 0, m22: 1, m23: 0, m24: 0,
            m31: 0, m32: 0, m33: 1, m34: 0,
            m41: 0, m42: 0, m43: 0, m44: 1
        )
    }
    
    public var elements: Distance {
        [
            .init(m11), .init(m12), .init(m13), .init(m14),
            .init(m21), .init(m23), .init(m23), .init(m24),
            .init(m31), .init(m32), .init(m33), .init(m34),
            .init(m41), .init(m42), .init(m43), .init(m44)
        ]
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Distance {
        [
            .init(lhs.m11 - rhs.m11), .init(lhs.m12 - rhs.m12),
            .init(lhs.m13 - rhs.m13), .init(lhs.m14 - rhs.m14),
            .init(lhs.m21 - rhs.m21), .init(lhs.m22 - rhs.m22),
            .init(lhs.m23 - rhs.m23), .init(lhs.m24 - rhs.m24),
            .init(lhs.m31 - rhs.m31), .init(lhs.m32 - rhs.m32),
            .init(lhs.m33 - rhs.m33), .init(lhs.m34 - rhs.m34),
            .init(lhs.m41 - rhs.m41), .init(lhs.m42 - rhs.m42),
            .init(lhs.m43 - rhs.m43), .init(lhs.m44 - rhs.m44)
        ]
    }
    
    public static func --+ (lhs: Self, rhs: Self) -> Self {
        .init(
            m11: lhs.m11 + rhs.m11,
            m12: lhs.m12 + rhs.m12,
            m13: lhs.m13 + rhs.m13,
            m14: lhs.m14 + rhs.m14,
            m21: lhs.m21 + rhs.m21,
            m22: lhs.m22 + rhs.m22,
            m23: lhs.m23 + rhs.m23,
            m24: lhs.m24 + rhs.m24,
            m31: lhs.m31 + rhs.m31,
            m32: lhs.m32 + rhs.m32,
            m33: lhs.m33 + rhs.m33,
            m34: lhs.m34 + rhs.m34,
            m41: lhs.m41 + rhs.m41,
            m42: lhs.m42 + rhs.m42,
            m43: lhs.m43 + rhs.m43,
            m44: lhs.m44 + rhs.m44
        )
    }
    
    public static func --+ (lhs: Distance, rhs: Self) -> Self {
        distanceAdd(lhs: lhs, rhs: rhs)
    }
    
    public static func --+ (lhs: Self, rhs: Distance) -> Self {
        distanceAdd(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceAdd(lhs: Distance, rhs: Self) -> Self {
        guard lhs.count >= 16 else { return rhs }
        return .init(
            m11: .init(lhs[0 ]),
            m12: .init(lhs[1 ]),
            m13: .init(lhs[2 ]),
            m14: .init(lhs[3 ]),
            m21: .init(lhs[4 ]),
            m22: .init(lhs[5 ]),
            m23: .init(lhs[6 ]),
            m24: .init(lhs[7 ]),
            m31: .init(lhs[8 ]),
            m32: .init(lhs[9 ]),
            m33: .init(lhs[10]),
            m34: .init(lhs[11]),
            m41: .init(lhs[12]),
            m42: .init(lhs[13]),
            m43: .init(lhs[14]),
            m44: .init(lhs[15])
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
            m11: .init(exactly: .init(lhs) * rhs.m11) ?? 0,
            m12: .init(exactly: .init(lhs) * rhs.m12) ?? 0,
            m13: .init(exactly: .init(lhs) * rhs.m13) ?? 0,
            m14: .init(exactly: .init(lhs) * rhs.m14) ?? 0,
            m21: .init(exactly: .init(lhs) * rhs.m21) ?? 0,
            m22: .init(exactly: .init(lhs) * rhs.m22) ?? 0,
            m23: .init(exactly: .init(lhs) * rhs.m23) ?? 0,
            m24: .init(exactly: .init(lhs) * rhs.m24) ?? 0,
            m31: .init(exactly: .init(lhs) * rhs.m31) ?? 0,
            m32: .init(exactly: .init(lhs) * rhs.m32) ?? 0,
            m33: .init(exactly: .init(lhs) * rhs.m33) ?? 0,
            m34: .init(exactly: .init(lhs) * rhs.m34) ?? 0,
            m41: .init(exactly: .init(lhs) * rhs.m41) ?? 0,
            m42: .init(exactly: .init(lhs) * rhs.m42) ?? 0,
            m43: .init(exactly: .init(lhs) * rhs.m43) ?? 0,
            m44: .init(exactly: .init(lhs) * rhs.m44) ?? 0
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
            m11: .init(exactly: .init(lhs) * rhs.m11) ?? 0,
            m12: .init(exactly: .init(lhs) * rhs.m12) ?? 0,
            m13: .init(exactly: .init(lhs) * rhs.m13) ?? 0,
            m14: .init(exactly: .init(lhs) * rhs.m14) ?? 0,
            m21: .init(exactly: .init(lhs) * rhs.m21) ?? 0,
            m22: .init(exactly: .init(lhs) * rhs.m22) ?? 0,
            m23: .init(exactly: .init(lhs) * rhs.m23) ?? 0,
            m24: .init(exactly: .init(lhs) * rhs.m24) ?? 0,
            m31: .init(exactly: .init(lhs) * rhs.m31) ?? 0,
            m32: .init(exactly: .init(lhs) * rhs.m32) ?? 0,
            m33: .init(exactly: .init(lhs) * rhs.m33) ?? 0,
            m34: .init(exactly: .init(lhs) * rhs.m34) ?? 0,
            m41: .init(exactly: .init(lhs) * rhs.m41) ?? 0,
            m42: .init(exactly: .init(lhs) * rhs.m42) ?? 0,
            m43: .init(exactly: .init(lhs) * rhs.m43) ?? 0,
            m44: .init(exactly: .init(lhs) * rhs.m44) ?? 0
        )
    }
    
}

