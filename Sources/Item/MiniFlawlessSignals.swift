//
//  MiniFlawlessSignals.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/3.
//

import CoreGraphics
import QuartzCore.CADisplayLink

public struct MiniFlawlessSignals {
    public typealias Action = (_ animateLink: CADisplayLink) -> Void
    public var start: Action? = nil
    public var pause: Action? = nil
    public var resume: Action? = nil
    public var stop: Action? = nil
    public typealias ProgressAction = (
        _ animateLink: CADisplayLink,
        _ progress: CGFloat
    ) -> Void
    public var progress: ProgressAction? = nil
    
    public init() { }
    
    public mutating func clean() {
        start = nil
        pause = nil
        resume = nil
        stop = nil
        progress = nil
    }
    
}