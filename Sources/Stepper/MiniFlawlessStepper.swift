//
//  MiniFlawlessStepper.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/3.
//

import Foundation
import CoreGraphics

public struct MiniFlawlessStepDistance<E: MiniFlawlessSteppable> {
    public var count: Int { elements.count }
    public var elements: [E] = []
    
    public init(elements: [E]) {
        self.elements = elements
    }
}

infix operator ---
infix operator --+
infix operator --+=
infix operator --*
infix operator --*=

public protocol MiniFlawlessSteppable {
    
    static var isClampable: Bool { get }
    static var zero: Self { get }
    
    var elements: Distance { get }
    static func --- (lhs: Self, rhs: Self) -> Distance
    
    static func --+ (lhs: Self, rhs: Self) -> Self
    static func --+ (lhs: Distance, rhs: Self) -> Self
    static func --+ (lhs: Self, rhs: Distance) -> Self
    
    static func --* <I: BinaryInteger>(lhs: I, rhs: Self) -> Self
    static func --* <I: BinaryInteger>(lhs: Self, rhs: I) -> Self
    
    static func --* <F: BinaryFloatingPoint>(lhs: F, rhs: Self) -> Self
    static func --* <F: BinaryFloatingPoint>(lhs: Self, rhs: F) -> Self
    
}

extension MiniFlawlessSteppable {
    
    public typealias Distance = [TimeInterval]
    
    public static func --+= (lhs: inout Self, rhs: Self) {
        lhs = lhs --+ rhs
    }
    
    public static func --* <I: BinaryInteger>(lhs: I, rhs: inout Self) {
        rhs = lhs --* rhs
    }
    
    public static func --* <I: BinaryInteger>(lhs: inout Self, rhs: I) {
        lhs = lhs --* rhs
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: F, rhs: inout Self) {
        rhs = lhs --* rhs
    }
    
    public static func --* <F: BinaryFloatingPoint>(lhs: inout Self, rhs: F) {
        lhs = lhs --* rhs
    }
    
}

open class MiniFlawlessStepper<Element: MiniFlawlessSteppable> {
    
    open var duration: TimeInterval = 0.25
    
    open var from: Element = .zero {
        didSet { distance = to --- from }
    }
    
    open var to: Element = .zero {
        didSet { distance = to --- from }
    }
    
    open private(set) var distance: Element.Distance = []
    
    public init(duration: TimeInterval, from: Element, to: Element) {
        self.duration = duration
        self.from = from
        self.to = to
        self.distance = to --- from
    }
    
    open func step(t: TimeInterval) -> Element { .zero }
    
    open func reverse() {
        (from, to) = (to, from)
    }
    
}
