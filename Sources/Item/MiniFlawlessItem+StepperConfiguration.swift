//
//  MiniFlawlessItem+StepperConfiguration.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/3.
//

import Foundation

public struct AnyStepperConfiguration<Element: MiniFlawlessSteppable> {
    
    public var duration: TimeInterval = 0.25
    public var from: Element = .zero
    public var to: Element = .zero
    
    public enum Mode {
        case spring(MiniFlawlessSpringStepper<Element>.Configuration)
        case tween(MiniFlawlessTweenStepper<Element>.Configuration)
        /// ignore duration & from & to
        case mechanics(MiniFlawlessMechanicsStepper<Element>.Configuration)
    }
    public var mode: Mode = .tween(.init(function: .linear))
    
}
