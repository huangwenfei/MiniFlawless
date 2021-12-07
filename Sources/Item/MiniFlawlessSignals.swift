//
//  MiniFlawlessSignals.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/3.
//

import CoreGraphics
import QuartzCore.CADisplayLink

public struct MiniFlawlessSignals<Element: MiniFlawlessSteppable> {
    public typealias Action = (_ item: MiniFlawlessItem<Element>) -> Void
    public var reset: Action? = nil
    public var reverse: Action? = nil
    public var start: Action? = nil
    public var pause: Action? = nil
    public var resume: Action? = nil
    public var stop: Action? = nil
    public typealias ProgressAction = (
        _ item: MiniFlawlessItem<Element>,
        _ eachProgress: TimeInterval,
        _ progress: TimeInterval
    ) -> Void
    public var progress: ProgressAction? = nil
    
    public init() { }
    
    public mutating func clean() {
        reset = nil
        reverse = nil
        start = nil
        pause = nil
        resume = nil
        stop = nil
        progress = nil
    }
    
}
