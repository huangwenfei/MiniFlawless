//
//  MiniFlawlessTweenStepper.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/3.
//

import Foundation
import CoreGraphics

public class MiniFlawlessTweenStepper<Element: MiniFlawlessSteppable>: MiniFlawlessStepper<Element> {

    open var configuration: Configuration
    
    public init(configuration: Configuration, duration: TimeInterval, from: Element, to: Element) {
        self.configuration = configuration
        super.init(duration: duration, from: from, to: to)
    }
    
    public override func step(t: TimeInterval) -> Element {

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

extension MiniFlawlessTweenStepper {
    public struct Configuration {
        public var function: MiniFlawlessTweenFunctionable.Type = MiniFlawlessTweenStepperFunction.Linear.self
        
        public init(function: MiniFlawlessTweenStepperFunction.Function) {
            self.function = function.value
        }
    }
}
