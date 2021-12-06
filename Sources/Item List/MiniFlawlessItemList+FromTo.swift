//
//  MiniFlawlessItemList+FromTo.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/5.
//

import Foundation

public struct MiniFlawlessItemListFromTo<Element: MiniFlawlessSteppable> {
    
    public var duration: TimeInterval = 0
    public var from: Element = .zero
    public var to: Element = .zero
    public private(set) var stepper: MiniFlawlessStepper<Element> = .init(
        duration: 0, from: .zero, to: .zero
    )
    
    public typealias Completion = (MiniFlawlessItemList<Element>) -> Void
    public var completion: Completion? = nil
    
    public init(duration: TimeInterval, from: Element, to: Element, stepper: AnyStepperConfiguration<Element>.Mode, completion: Completion? = nil) {
        self.duration = duration
        self.from = from
        self.to = to
        
        updateStepper(by: stepper)
    }
    
    public mutating func updateStepper(by new: AnyStepperConfiguration<Element>.Mode) {
        switch new {
        case let .spring(configs):
            stepper = MiniFlawlessSpringStepper<Element>.init(
                configuration: configs,
                from: from,
                to: to
            )
        case let .tween(configs):
            stepper = MiniFlawlessTweenStepper<Element>.init(
                configuration: configs,
                duration: duration,
                from: from,
                to: to
            )
        }
    }
    
}
