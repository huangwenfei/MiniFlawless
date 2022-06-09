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
    
    public static prefix func --- (value: Self) -> Self {
        .init(
            a:  -value.a,
            b:  -value.b,
            c:  -value.c,
            d:  -value.d,
            tx: -value.tx,
            ty: -value.ty
        )
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Self {
        .init(
            a:  lhs.a  - rhs.a,
            b:  lhs.b  - rhs.b,
            c:  lhs.c  - rhs.c,
            d:  lhs.d  - rhs.d,
            tx: lhs.tx - rhs.tx,
            ty: lhs.ty - rhs.ty
        )
    }
    
    public static func ---> (lhs: Self, rhs: Self) -> Distance {
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
            a:  CGFloat(lhs[0]),
            b:  CGFloat(lhs[0]),
            c:  CGFloat(lhs[0]),
            d:  CGFloat(lhs[0]),
            tx: CGFloat(lhs[0]),
            ty: CGFloat(lhs[0])
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
            a:  CGFloat(exactly: CGFloat(lhs) * rhs.a) ?? 0,
            b:  CGFloat(exactly: CGFloat(lhs) * rhs.b) ?? 0,
            c:  CGFloat(exactly: CGFloat(lhs) * rhs.c) ?? 0,
            d:  CGFloat(exactly: CGFloat(lhs) * rhs.d) ?? 0,
            tx: CGFloat(exactly: CGFloat(lhs) * rhs.tx) ?? 0,
            ty: CGFloat(exactly: CGFloat(lhs) * rhs.ty) ?? 0
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
            a:  CGFloat(exactly: CGFloat(lhs) * rhs.a) ?? 0,
            b:  CGFloat(exactly: CGFloat(lhs) * rhs.b) ?? 0,
            c:  CGFloat(exactly: CGFloat(lhs) * rhs.c) ?? 0,
            d:  CGFloat(exactly: CGFloat(lhs) * rhs.d) ?? 0,
            tx: CGFloat(exactly: CGFloat(lhs) * rhs.tx) ?? 0,
            ty: CGFloat(exactly: CGFloat(lhs) * rhs.ty) ?? 0
        )
    }
    
    
    public static func --/ <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        .init(
            a:  CGFloat(exactly: CGFloat(lhs) / rhs.a) ?? 0,
            b:  CGFloat(exactly: CGFloat(lhs) / rhs.b) ?? 0,
            c:  CGFloat(exactly: CGFloat(lhs) / rhs.c) ?? 0,
            d:  CGFloat(exactly: CGFloat(lhs) / rhs.d) ?? 0,
            tx: CGFloat(exactly: CGFloat(lhs) / rhs.tx) ?? 0,
            ty: CGFloat(exactly: CGFloat(lhs) / rhs.ty) ?? 0
        )
    }
    
    public static func --/ <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        .init(
            a:  CGFloat(exactly: lhs.a  / CGFloat(rhs)) ?? 0,
            b:  CGFloat(exactly: lhs.b  / CGFloat(rhs)) ?? 0,
            c:  CGFloat(exactly: lhs.c  / CGFloat(rhs)) ?? 0,
            d:  CGFloat(exactly: lhs.d  / CGFloat(rhs)) ?? 0,
            tx: CGFloat(exactly: lhs.tx / CGFloat(rhs)) ?? 0,
            ty: CGFloat(exactly: lhs.ty / CGFloat(rhs)) ?? 0
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        .init(
            a:  CGFloat(exactly: CGFloat(lhs) / rhs.a) ?? 0,
            b:  CGFloat(exactly: CGFloat(lhs) / rhs.b) ?? 0,
            c:  CGFloat(exactly: CGFloat(lhs) / rhs.c) ?? 0,
            d:  CGFloat(exactly: CGFloat(lhs) / rhs.d) ?? 0,
            tx: CGFloat(exactly: CGFloat(lhs) / rhs.tx) ?? 0,
            ty: CGFloat(exactly: CGFloat(lhs) / rhs.ty) ?? 0
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        .init(
            a:  CGFloat(exactly: lhs.a  / CGFloat(rhs)) ?? 0,
            b:  CGFloat(exactly: lhs.b  / CGFloat(rhs)) ?? 0,
            c:  CGFloat(exactly: lhs.c  / CGFloat(rhs)) ?? 0,
            d:  CGFloat(exactly: lhs.d  / CGFloat(rhs)) ?? 0,
            tx: CGFloat(exactly: lhs.tx / CGFloat(rhs)) ?? 0,
            ty: CGFloat(exactly: lhs.ty / CGFloat(rhs)) ?? 0
        )
    }
    
}

extension CGAffineTransform: MiniFlawlessMechanicsSteppable {
    
    public var length: Double {
        sqrt(a * a + b * b + c * c + d * d + tx * tx + ty * ty)
    }
    
    public func distance(toSegment segment: (from: Self, to: Self)) -> Double {
        let v = segment.0
        let w = segment.1
    
        let pv_da = a - v.a
        let pv_db = b - v.b
        let pv_dc = c - v.c
        let pv_dd = d - v.d
        let pv_dx = tx - v.tx
        let pv_dy = ty - v.ty
        
        let wv_da = w.a - v.a
        let wv_db = w.b - v.b
        let wv_dc = w.c - v.c
        let wv_dd = w.d - v.d
        let wv_dx = w.tx - v.tx
        let wv_dy = w.ty - v.ty

        let dot = pv_da * wv_da + pv_db * wv_db + pv_dc * wv_dc + pv_dd * wv_dd + pv_dx * wv_dx + pv_dy * wv_dy
        let len_sq = wv_da * wv_da + wv_db * wv_db + wv_dc * wv_dc + wv_dd * wv_dd + wv_dx * wv_dx + wv_dy * wv_dy
        let param = dot / len_sq

        var int_a, int_b, int_c, int_d, int_dx, int_dy: Double /* intersection of normal to vw that goes through p */

        if param < 0 || (v.a == w.a && v.b == w.b && v.c == w.c && v.d == w.d && v.tx == w.tx && v.ty == w.ty) {
            int_a = v.a
            int_b = v.b
            int_c = v.c
            int_d = v.d
            int_dx = v.tx
            int_dy = v.ty
        } else if param > 1 {
            int_a = w.a
            int_b = w.b
            int_c = w.c
            int_d = w.d
            int_dx = w.tx
            int_dy = w.ty
        } else {
            int_a = v.a + param * wv_da
            int_b = v.b + param * wv_db
            int_c = v.c + param * wv_dc
            int_d = v.d + param * wv_dd
            int_dx = v.tx + param * wv_dx
            int_dy = v.ty + param * wv_dy
        }

        /* Components of normal */
        let da = a - int_a
        let db = b - int_b
        let dc = c - int_c
        let dd = d - int_d
        let dx = tx - int_dx
        let dy = ty - int_dy

        return sqrt(da * da + db * db + dc * dc + dd * dd + dx * dx + dy * dy)
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
    
    public static prefix func --- (value: Self) -> Self {
        .init(
            m11: .zero - value.m11,
            m12: .zero - value.m12,
            m13: .zero - value.m13,
            m14: .zero - value.m14,
            m21: .zero - value.m21,
            m22: .zero - value.m22,
            m23: .zero - value.m23,
            m24: .zero - value.m24,
            m31: .zero - value.m31,
            m32: .zero - value.m32,
            m33: .zero - value.m33,
            m34: .zero - value.m34,
            m41: .zero - value.m41,
            m42: .zero - value.m42,
            m43: .zero - value.m43,
            m44: .zero - value.m44
        )
    }
    
    public static func --- (lhs: Self, rhs: Self) -> Self {
        .init(
            m11: lhs.m11 - rhs.m11,
            m12: lhs.m12 - rhs.m12,
            m13: lhs.m13 - rhs.m13,
            m14: lhs.m14 - rhs.m14,
            m21: lhs.m21 - rhs.m21,
            m22: lhs.m22 - rhs.m22,
            m23: lhs.m23 - rhs.m23,
            m24: lhs.m24 - rhs.m24,
            m31: lhs.m31 - rhs.m31,
            m32: lhs.m32 - rhs.m32,
            m33: lhs.m33 - rhs.m33,
            m34: lhs.m34 - rhs.m34,
            m41: lhs.m41 - rhs.m41,
            m42: lhs.m42 - rhs.m42,
            m43: lhs.m43 - rhs.m43,
            m44: lhs.m44 - rhs.m44
        )
    }
    
    public static func ---> (lhs: Self, rhs: Self) -> Distance {
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
        CATransform3D(
            m11: CGFloat(exactly: CGFloat(lhs) * rhs.m11) ?? 0,
            m12: CGFloat(exactly: CGFloat(lhs) * rhs.m12) ?? 0,
            m13: CGFloat(exactly: CGFloat(lhs) * rhs.m13) ?? 0,
            m14: CGFloat(exactly: CGFloat(lhs) * rhs.m14) ?? 0,
            m21: CGFloat(exactly: CGFloat(lhs) * rhs.m21) ?? 0,
            m22: CGFloat(exactly: CGFloat(lhs) * rhs.m22) ?? 0,
            m23: CGFloat(exactly: CGFloat(lhs) * rhs.m23) ?? 0,
            m24: CGFloat(exactly: CGFloat(lhs) * rhs.m24) ?? 0,
            m31: CGFloat(exactly: CGFloat(lhs) * rhs.m31) ?? 0,
            m32: CGFloat(exactly: CGFloat(lhs) * rhs.m32) ?? 0,
            m33: CGFloat(exactly: CGFloat(lhs) * rhs.m33) ?? 0,
            m34: CGFloat(exactly: CGFloat(lhs) * rhs.m34) ?? 0,
            m41: CGFloat(exactly: CGFloat(lhs) * rhs.m41) ?? 0,
            m42: CGFloat(exactly: CGFloat(lhs) * rhs.m42) ?? 0,
            m43: CGFloat(exactly: CGFloat(lhs) * rhs.m43) ?? 0,
            m44: CGFloat(exactly: CGFloat(lhs) * rhs.m44) ?? 0
        )
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        distanceMultiply(lhs: lhs, rhs: rhs)
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        distanceMultiply(lhs: rhs, rhs: lhs)
    }
    
    private static func distanceMultiply<F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        CATransform3D(
            m11: CGFloat(exactly: CGFloat(lhs) * rhs.m11) ?? 0,
            m12: CGFloat(exactly: CGFloat(lhs) * rhs.m12) ?? 0,
            m13: CGFloat(exactly: CGFloat(lhs) * rhs.m13) ?? 0,
            m14: CGFloat(exactly: CGFloat(lhs) * rhs.m14) ?? 0,
            m21: CGFloat(exactly: CGFloat(lhs) * rhs.m21) ?? 0,
            m22: CGFloat(exactly: CGFloat(lhs) * rhs.m22) ?? 0,
            m23: CGFloat(exactly: CGFloat(lhs) * rhs.m23) ?? 0,
            m24: CGFloat(exactly: CGFloat(lhs) * rhs.m24) ?? 0,
            m31: CGFloat(exactly: CGFloat(lhs) * rhs.m31) ?? 0,
            m32: CGFloat(exactly: CGFloat(lhs) * rhs.m32) ?? 0,
            m33: CGFloat(exactly: CGFloat(lhs) * rhs.m33) ?? 0,
            m34: CGFloat(exactly: CGFloat(lhs) * rhs.m34) ?? 0,
            m41: CGFloat(exactly: CGFloat(lhs) * rhs.m41) ?? 0,
            m42: CGFloat(exactly: CGFloat(lhs) * rhs.m42) ?? 0,
            m43: CGFloat(exactly: CGFloat(lhs) * rhs.m43) ?? 0,
            m44: CGFloat(exactly: CGFloat(lhs) * rhs.m44) ?? 0
        )
    }
    
    
    public static func --/ <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        CATransform3D(
            m11: CGFloat(exactly: CGFloat(lhs) / rhs.m11) ?? 0,
            m12: CGFloat(exactly: CGFloat(lhs) / rhs.m12) ?? 0,
            m13: CGFloat(exactly: CGFloat(lhs) / rhs.m13) ?? 0,
            m14: CGFloat(exactly: CGFloat(lhs) / rhs.m14) ?? 0,
            m21: CGFloat(exactly: CGFloat(lhs) / rhs.m21) ?? 0,
            m22: CGFloat(exactly: CGFloat(lhs) / rhs.m22) ?? 0,
            m23: CGFloat(exactly: CGFloat(lhs) / rhs.m23) ?? 0,
            m24: CGFloat(exactly: CGFloat(lhs) / rhs.m24) ?? 0,
            m31: CGFloat(exactly: CGFloat(lhs) / rhs.m31) ?? 0,
            m32: CGFloat(exactly: CGFloat(lhs) / rhs.m32) ?? 0,
            m33: CGFloat(exactly: CGFloat(lhs) / rhs.m33) ?? 0,
            m34: CGFloat(exactly: CGFloat(lhs) / rhs.m34) ?? 0,
            m41: CGFloat(exactly: CGFloat(lhs) / rhs.m41) ?? 0,
            m42: CGFloat(exactly: CGFloat(lhs) / rhs.m42) ?? 0,
            m43: CGFloat(exactly: CGFloat(lhs) / rhs.m43) ?? 0,
            m44: CGFloat(exactly: CGFloat(lhs) / rhs.m44) ?? 0
        )
    }
    
    public static func --/ <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        CATransform3D(
            m11: CGFloat(exactly: lhs.m11 / CGFloat(rhs)) ?? 0,
            m12: CGFloat(exactly: lhs.m12 / CGFloat(rhs)) ?? 0,
            m13: CGFloat(exactly: lhs.m13 / CGFloat(rhs)) ?? 0,
            m14: CGFloat(exactly: lhs.m14 / CGFloat(rhs)) ?? 0,
            m21: CGFloat(exactly: lhs.m21 / CGFloat(rhs)) ?? 0,
            m22: CGFloat(exactly: lhs.m22 / CGFloat(rhs)) ?? 0,
            m23: CGFloat(exactly: lhs.m23 / CGFloat(rhs)) ?? 0,
            m24: CGFloat(exactly: lhs.m24 / CGFloat(rhs)) ?? 0,
            m31: CGFloat(exactly: lhs.m31 / CGFloat(rhs)) ?? 0,
            m32: CGFloat(exactly: lhs.m32 / CGFloat(rhs)) ?? 0,
            m33: CGFloat(exactly: lhs.m33 / CGFloat(rhs)) ?? 0,
            m34: CGFloat(exactly: lhs.m34 / CGFloat(rhs)) ?? 0,
            m41: CGFloat(exactly: lhs.m41 / CGFloat(rhs)) ?? 0,
            m42: CGFloat(exactly: lhs.m42 / CGFloat(rhs)) ?? 0,
            m43: CGFloat(exactly: lhs.m43 / CGFloat(rhs)) ?? 0,
            m44: CGFloat(exactly: lhs.m44 / CGFloat(rhs)) ?? 0
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self {
        CATransform3D(
            m11: CGFloat(exactly: CGFloat(lhs) / rhs.m11) ?? 0,
            m12: CGFloat(exactly: CGFloat(lhs) / rhs.m12) ?? 0,
            m13: CGFloat(exactly: CGFloat(lhs) / rhs.m13) ?? 0,
            m14: CGFloat(exactly: CGFloat(lhs) / rhs.m14) ?? 0,
            m21: CGFloat(exactly: CGFloat(lhs) / rhs.m21) ?? 0,
            m22: CGFloat(exactly: CGFloat(lhs) / rhs.m22) ?? 0,
            m23: CGFloat(exactly: CGFloat(lhs) / rhs.m23) ?? 0,
            m24: CGFloat(exactly: CGFloat(lhs) / rhs.m24) ?? 0,
            m31: CGFloat(exactly: CGFloat(lhs) / rhs.m31) ?? 0,
            m32: CGFloat(exactly: CGFloat(lhs) / rhs.m32) ?? 0,
            m33: CGFloat(exactly: CGFloat(lhs) / rhs.m33) ?? 0,
            m34: CGFloat(exactly: CGFloat(lhs) / rhs.m34) ?? 0,
            m41: CGFloat(exactly: CGFloat(lhs) / rhs.m41) ?? 0,
            m42: CGFloat(exactly: CGFloat(lhs) / rhs.m42) ?? 0,
            m43: CGFloat(exactly: CGFloat(lhs) / rhs.m43) ?? 0,
            m44: CGFloat(exactly: CGFloat(lhs) / rhs.m44) ?? 0
        )
    }
    
    public static func --/ <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self {
        CATransform3D(
            m11: CGFloat(exactly: lhs.m11 / CGFloat(rhs)) ?? 0,
            m12: CGFloat(exactly: lhs.m12 / CGFloat(rhs)) ?? 0,
            m13: CGFloat(exactly: lhs.m13 / CGFloat(rhs)) ?? 0,
            m14: CGFloat(exactly: lhs.m14 / CGFloat(rhs)) ?? 0,
            m21: CGFloat(exactly: lhs.m21 / CGFloat(rhs)) ?? 0,
            m22: CGFloat(exactly: lhs.m22 / CGFloat(rhs)) ?? 0,
            m23: CGFloat(exactly: lhs.m23 / CGFloat(rhs)) ?? 0,
            m24: CGFloat(exactly: lhs.m24 / CGFloat(rhs)) ?? 0,
            m31: CGFloat(exactly: lhs.m31 / CGFloat(rhs)) ?? 0,
            m32: CGFloat(exactly: lhs.m32 / CGFloat(rhs)) ?? 0,
            m33: CGFloat(exactly: lhs.m33 / CGFloat(rhs)) ?? 0,
            m34: CGFloat(exactly: lhs.m34 / CGFloat(rhs)) ?? 0,
            m41: CGFloat(exactly: lhs.m41 / CGFloat(rhs)) ?? 0,
            m42: CGFloat(exactly: lhs.m42 / CGFloat(rhs)) ?? 0,
            m43: CGFloat(exactly: lhs.m43 / CGFloat(rhs)) ?? 0,
            m44: CGFloat(exactly: lhs.m44 / CGFloat(rhs)) ?? 0
        )
    }
    
}

extension CATransform3D: MiniFlawlessMechanicsSteppable {
    
    public var length: Double {
        sqrt(
            m11 * m11 + m12 * m12 + m13 * m13 + m14 * m14 +
            m21 * m21 + m22 * m22 + m23 * m23 + m24 * m24 +
            m31 * m31 + m32 * m32 + m33 * m33 + m34 * m34 +
            m41 * m41 + m42 * m42 + m43 * m43 + m44 * m44
        )
    }
    
    public func distance(toSegment segment: (from: Self, to: Self)) -> Double {
        let v = segment.0
        let w = segment.1
    
        let pv_dm11 = m11 - v.m11
        let pv_dm12 = m12 - v.m12
        let pv_dm13 = m13 - v.m13
        let pv_dm14 = m14 - v.m14
        let pv_dm21 = m21 - v.m21
        let pv_dm22 = m22 - v.m22
        let pv_dm23 = m23 - v.m23
        let pv_dm24 = m24 - v.m24
        let pv_dm31 = m31 - v.m31
        let pv_dm32 = m32 - v.m32
        let pv_dm33 = m33 - v.m33
        let pv_dm34 = m34 - v.m34
        let pv_dm41 = m41 - v.m41
        let pv_dm42 = m42 - v.m42
        let pv_dm43 = m43 - v.m43
        let pv_dm44 = m44 - v.m44
        
        let wv_dm11 = w.m11 - v.m11
        let wv_dm12 = w.m12 - v.m12
        let wv_dm13 = w.m13 - v.m13
        let wv_dm14 = w.m14 - v.m14
        let wv_dm21 = w.m21 - v.m21
        let wv_dm22 = w.m22 - v.m22
        let wv_dm23 = w.m23 - v.m23
        let wv_dm24 = w.m24 - v.m24
        let wv_dm31 = w.m31 - v.m31
        let wv_dm32 = w.m32 - v.m32
        let wv_dm33 = w.m33 - v.m33
        let wv_dm34 = w.m34 - v.m34
        let wv_dm41 = w.m41 - v.m41
        let wv_dm42 = w.m42 - v.m42
        let wv_dm43 = w.m43 - v.m43
        let wv_dm44 = w.m44 - v.m44

        let dot =
            pv_dm11 * wv_dm11 + pv_dm12 * wv_dm12 + pv_dm13 * wv_dm13 + pv_dm14 * wv_dm14 +
            pv_dm21 * wv_dm21 + pv_dm22 * wv_dm22 + pv_dm23 * wv_dm23 + pv_dm24 * wv_dm24 +
            pv_dm31 * wv_dm31 + pv_dm32 * wv_dm32 + pv_dm33 * wv_dm33 + pv_dm34 * wv_dm34 +
            pv_dm41 * wv_dm41 + pv_dm42 * wv_dm42 + pv_dm43 * wv_dm43 + pv_dm44 * wv_dm44
        
        let len_sq =
            wv_dm11 * wv_dm11 + wv_dm12 * wv_dm12 + wv_dm13 * wv_dm13 + wv_dm14 * wv_dm14 +
            wv_dm21 * wv_dm21 + wv_dm22 * wv_dm22 + wv_dm23 * wv_dm23 + wv_dm24 * wv_dm24 +
            wv_dm31 * wv_dm31 + wv_dm32 * wv_dm32 + wv_dm33 * wv_dm33 + wv_dm34 * wv_dm34 +
            wv_dm41 * wv_dm41 + wv_dm42 * wv_dm42 + wv_dm43 * wv_dm43 + wv_dm44 * wv_dm44
        
        let param = dot / len_sq

        var int_m11, int_m12, int_m13, int_m14,
            int_m21, int_m22, int_m23, int_m24,
            int_m31, int_m32, int_m33, int_m34,
            int_m41, int_m42, int_m43, int_m44: Double /* intersection of normal to vw that goes through p */

        if
            param < 0 || (
                v.m11 == w.m11 && v.m12 == w.m12 && v.m13 == w.m13 && v.m14 == w.m14 &&
                v.m21 == w.m21 && v.m22 == w.m22 && v.m23 == w.m23 && v.m24 == w.m24 &&
                v.m31 == w.m31 && v.m32 == w.m32 && v.m33 == w.m33 && v.m34 == w.m34 &&
                v.m41 == w.m41 && v.m42 == w.m42 && v.m43 == w.m43 && v.m44 == w.m44
            )
        {
            int_m11 = v.m11
            int_m12 = v.m12
            int_m13 = v.m13
            int_m14 = v.m14
            int_m21 = v.m21
            int_m22 = v.m22
            int_m23 = v.m23
            int_m24 = v.m24
            int_m31 = v.m31
            int_m32 = v.m32
            int_m33 = v.m33
            int_m34 = v.m34
            int_m41 = v.m41
            int_m42 = v.m42
            int_m43 = v.m43
            int_m44 = v.m44
        } else if param > 1 {
            int_m11 = w.m11
            int_m12 = w.m12
            int_m13 = w.m13
            int_m14 = w.m14
            int_m21 = w.m21
            int_m22 = w.m22
            int_m23 = w.m23
            int_m24 = w.m24
            int_m31 = w.m31
            int_m32 = w.m32
            int_m33 = w.m33
            int_m34 = w.m34
            int_m41 = w.m41
            int_m42 = w.m42
            int_m43 = w.m43
            int_m44 = w.m44
        } else {
            int_m11 = v.m11 + param * wv_dm11
            int_m12 = v.m12 + param * wv_dm12
            int_m13 = v.m13 + param * wv_dm13
            int_m14 = v.m14 + param * wv_dm14
            int_m21 = v.m21 + param * wv_dm21
            int_m22 = v.m22 + param * wv_dm22
            int_m23 = v.m23 + param * wv_dm23
            int_m24 = v.m24 + param * wv_dm24
            int_m31 = v.m31 + param * wv_dm31
            int_m32 = v.m32 + param * wv_dm32
            int_m33 = v.m33 + param * wv_dm33
            int_m34 = v.m34 + param * wv_dm34
            int_m41 = v.m41 + param * wv_dm41
            int_m42 = v.m42 + param * wv_dm42
            int_m43 = v.m43 + param * wv_dm43
            int_m44 = v.m44 + param * wv_dm44
        }

        /* Components of normal */
        let dm11 = m11 - int_m11
        let dm12 = m12 - int_m12
        let dm13 = m13 - int_m13
        let dm14 = m14 - int_m14
        let dm21 = m21 - int_m21
        let dm22 = m22 - int_m22
        let dm23 = m23 - int_m23
        let dm24 = m24 - int_m24
        let dm31 = m31 - int_m31
        let dm32 = m32 - int_m32
        let dm33 = m33 - int_m33
        let dm34 = m34 - int_m34
        let dm41 = m41 - int_m41
        let dm42 = m42 - int_m42
        let dm43 = m43 - int_m43
        let dm44 = m44 - int_m44

        return sqrt(
            dm11 * dm11 + dm12 * dm12 + dm13 * dm13 + dm14 * dm14 +
            dm21 * dm21 + dm22 * dm22 + dm23 * dm23 + dm24 * dm24 +
            dm31 * dm31 + dm32 * dm32 + dm33 * dm33 + dm34 * dm34 +
            dm41 * dm41 + dm42 * dm42 + dm43 * dm43 + dm44 * dm44
        )
    }
    
}
