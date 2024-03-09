//
//  MiniFlawlessTweenStepper.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/3.
//

import Foundation
import CoreGraphics

open class MiniFlawlessTweenStepper<Element: MiniFlawlessSteppable>: MiniFlawlessStepper<Element> {

    public typealias Configuration = MiniFlawlessTweenStepperConfiguration
    
    open var configuration: Configuration
    
    public init(configuration: Configuration, duration: TimeInterval, from: Element, to: Element) {
        self.configuration = configuration
        super.init(duration: duration, from: from, to: to)
    }
    
    open override func step(t: TimeInterval) -> Element {

        let time = min(max(t, 0), duration)
        
        let function = configuration.function
        
        let factor = function.step(t: time / duration)
        
        #if false && DEBUG
        print(#function, "factor", factor, "distance", distance)
        #endif
        
        let offset = factor --* distance
        
        #if false && DEBUG
        print(#function, "offset", offset)
        #endif
        
        let current = from --+ offset
        
        #if false && DEBUG
        print(#function, "current", current)
        #endif
        
        return current
        
    }
    
}

public struct MiniFlawlessTweenStepperConfiguration {
    public var function: MiniFlawlessTweenFunctionable.Type = MiniFlawlessTweenStepperFunction.Linear.self
    
    public init(function: MiniFlawlessTweenStepperFunction.Function) {
        self.function = function.value
    }
    
    public static func function(_ method: MiniFlawlessTweenStepperFunction.Function) -> Self {
        .init(function: method)
    }
}

extension MiniFlawlessTweenStepperConfiguration {
    @inlinable public static var linear:               Self { .function(.linear) }
    @inlinable public static var easeInQuadratic:      Self { .function(.easeInQuadratic) }
    @inlinable public static var easeOutQuadratic:     Self { .function(.easeOutQuadratic) }
    @inlinable public static var easeInOutQuadratic:   Self { .function(.easeInOutQuadratic) }
    @inlinable public static var easeInCubic:          Self { .function(.easeInCubic) }
    @inlinable public static var easeOutCubic:         Self { .function(.easeOutCubic) }
    @inlinable public static var easeInOutCubic:       Self { .function(.easeInOutCubic) }
    @inlinable public static var easeInQuartic:        Self { .function(.easeInQuartic) }
    @inlinable public static var easeOutQuartic:       Self { .function(.easeOutQuartic) }
    @inlinable public static var easeInOutQuartic:     Self { .function(.easeInOutQuartic) }
    @inlinable public static var easeInQuintic:        Self { .function(.easeInQuintic) }
    @inlinable public static var easeOutQuintic:       Self { .function(.easeOutQuintic) }
    @inlinable public static var easeInOutQuintic:     Self { .function(.easeInOutQuintic) }
    @inlinable public static var easeInSine:           Self { .function(.easeInSine) }
    @inlinable public static var easeOutSine:          Self { .function(.easeOutSine) }
    @inlinable public static var easeInOutSine:        Self { .function(.easeInOutSine) }
    @inlinable public static var easeInCircular:       Self { .function(.easeInCircular) }
    @inlinable public static var easeOutCircular:      Self { .function(.easeOutCircular) }
    @inlinable public static var easeInOutCircular:    Self { .function(.easeInOutCircular) }
    @inlinable public static var easeInExponencial:    Self { .function(.easeInExponencial) }
    @inlinable public static var easeOutExponencial:   Self { .function(.easeOutExponencial) }
    @inlinable public static var easeInOutExponencial: Self { .function(.easeInOutExponencial) }
    @inlinable public static var easeInElastic:        Self { .function(.easeInElastic) }
    @inlinable public static var easeOutElastic:       Self { .function(.easeOutElastic) }
    @inlinable public static var easeInOutElastic:     Self { .function(.easeInOutElastic) }
    @inlinable public static var easeInBack:           Self { .function(.easeInBack) }
    @inlinable public static var easeOutBack:          Self { .function(.easeOutBack) }
    @inlinable public static var easeInOutBack:        Self { .function(.easeInOutBack) }
    @inlinable public static var easeInBounce:         Self { .function(.easeInBounce) }
    @inlinable public static var easeOutBounce:        Self { .function(.easeOutBounce) }
    @inlinable public static var easeInOutBounce:      Self { .function(.easeInOutBounce) }
}
