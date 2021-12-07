//
//  MiniFlawlessItem.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/3.
//

import Foundation
import QuartzCore

/// 保存了一个动画因子的起点和终点，及时间元信息
public struct MiniFlawlessItem<Element: MiniFlawlessSteppable> {
    
    /// - Tag: Base
    
    public var name: String = ""
    
//    @Protected
//    public var state: MiniFlawlessItemState = .stop
    
    /// Each Duration Or Total Duration
    public var duration: TimeInterval = 0 {
        didSet {
            updatetDurations()
        }
    }
    
    public private(set) var eachDuration: TimeInterval = 0
    
    public private(set) var totalDuration: TimeInterval = 0
    
    public var from: Element = .zero {
        didSet {
            current = from
            stepper.from = from
        }
    }
    
    public var to: Element = .zero {
        didSet {
            stepper.to = to
        }
    }
    
    public private(set) var stepper: MiniFlawlessStepper<Element> = .init(
        duration: 0, from: .zero, to: .zero
    )
    
    /// - Tag: Write Back
    
    public typealias WriteBack = (_ current: Element, _ eachProgress: TimeInterval, _ progress: TimeInterval) -> Void
    
    public var writeBack: WriteBack? = nil
    
    public func startWrite() {
        uiThread { self.writeBack?(from, 0, 0) }
    }
    
    public func write() {
        uiThread { self.writeBack?(current, eachProgress, progress) }
    }
    
    /// - Tag: Progress
    
    internal var eachProgress: TimeInterval {
        #if false && DEBUG
        print(#function, eachCurrentTime, eachDuration, currentTime, passRunCount)
        #endif
        return min(max(eachCurrentTime / eachDuration, 0), 1)
    }
    
    internal var progress: TimeInterval {
        min(max(currentTime / totalDuration, 0), 1)
    }
    
    /// - Tag: Completion
    
    /// Only vaild in Item troup .
    public var isRemoveOnCompletion: Bool = true
    
    @Protected
    public var isFinished: Bool = false
    
    public typealias Completion = (Self) -> Void
    public var completion: Completion? = nil
    
    /// 一个运动周期结束后调用
    /// 如： Auto Reverse = true, foreverRun = false, eachCompletion 会被调用一次
    /// 如：repeatCount > 1, foreverRun = false, Auto Reverse = false, eachCompletion 会被调用 repeatCount - 1 次
    /// 如：foreverRun = true, eachCompletion 会被调用 futureCount - 1 次
    public var eachCompletion: Completion? = nil
    
    internal func completeIt() {
        $isFinished.write { $0 = true }
        
        guard doneFillMode != .none else {
            completion?(self)
            return
        }
        
        let isReverse = isAutoReverse && (passRunCount % 2 == 0)
        let from = isReverse ? self.to : self.from
        let to = isReverse ? self.from : self.to
        switch doneFillMode {
        case .none: break
        case .from: writeBack?(from, 1, 1)
        case .to:   writeBack?(to, 1, 1)
        }
        completion?(self)
    }
    
    internal func eachCompletIt() {
        eachCompletion?(self)
    }
    
    internal func stopCompletion() {
        $isFinished.write { $0 = isDone }
        completion?(self)
    }
    
    /// - Tag: Repeat
    
    public var isAutoReverse: Bool = false
    public var isForeverRun: Bool = false
    
    @Protected
    public var repeatCount: Int = 0
    
    private let futureCount: Int = 10000

    public var runCount: Int {
        var count = repeatCount
        if count == 0 { count = 1 }
        
        return isForeverRun
            ? futureCount
            : (count * ( isAutoReverse ? 2 : 1 ))
    }
    
    /// - Tag: Current
    
    @Protected
    internal var current: Element = .zero
    
    @Protected
    internal var currentTime: TimeInterval = 0
    
    @Protected
    internal var eachCurrentTime: TimeInterval = 0
    
    @Protected
    public var passRunCount: Int = 0
    
    public func updateCurrent() {
        $current.write { $0 = stepper.step(t: eachCurrentTime) }
    }
    
    public func updateCurrentTime(by time: TimeInterval) {
        $currentTime.write { $0 += time }
        $eachCurrentTime.write {
            $0 = currentTime - .init(passRunCount) * eachDuration
        }
    }
    
    public func updateRunCount() {
        $passRunCount.write { $0 += 1 }
    }
    
    /// - Tag: Done
    
    public var doneFillMode: MiniFlawlessItemFillMode = .to
    
    internal var isEachDone: Bool {
        eachCurrentTime >= eachDuration
    }
    
    internal var isDone: Bool {
        currentTime >= totalDuration
    }
    
    /// - Tag: Init
    
    public init(name: String = "", duration: TimeInterval, from: Element, to: Element, stepper: AnyStepperConfiguration<Element>.Mode, isAutoReverse: Bool = false, isForeverRun: Bool = false, repeatCount: Int = 1, eachCompletion: Completion? = nil, writeBack: WriteBack? = nil, isRemoveOnCompletion: Bool = false, doneFillMode: MiniFlawlessItemFillMode = .to, completion: Completion? = nil) {
        
        self.name = name
        self.duration = duration
        self.from = from
        self.to = to
        self.isAutoReverse = isAutoReverse
        self.isForeverRun = isForeverRun
        self.repeatCount = repeatCount
        self.eachCompletion = eachCompletion
        self.writeBack = writeBack
        self.isRemoveOnCompletion = isRemoveOnCompletion
        self.doneFillMode = doneFillMode
        self.completion = completion
        self.current = from
        
        updateStepper(by: stepper)
        updatetDurations()
        
    }
    
    /// - Tag: Update
    
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
                duration: eachDuration,
                from: from,
                to: to
            )
        }
    }
    
    private mutating func updatetDurations() {
        
        let count: TimeInterval = .init(runCount)
        let duration = self.duration < 0 ? 0.25 : self.duration
        
        eachDuration = duration * (isAutoReverse ? 0.5 : 1)
        
        totalDuration = eachDuration * count
        
        stepper.duration = eachDuration
        
    }
    
    /// - Tag: Reset
    
    public func futureReset() -> Self {
        let result = self
        result.$current.write { $0 = from }
        result.write()
        return result
    }
    
    public mutating func futureReseted() {
        $current.write { $0 = from }
        write()
    }
    
    public func reset() -> Self {
        let result = self
        result.$current.write { $0 = from }
        result.$currentTime.write { $0 = 0 }
        result.$eachCurrentTime.write { $0 = 0 }
        result.$passRunCount.write { $0 = 0 }
        result.$isFinished.write { $0 = false }
        return result
    }
    
    public mutating func reseted() {
        $current.write { $0 = from }
        $currentTime.write { $0 = 0 }
        $eachCurrentTime.write { $0 = 0 }
        $passRunCount.write { $0 = 0 }
        $isFinished.write { $0 = false }
    }
    
    /// - Tag: Reverse
    
    public func reverse(newName: String = "") -> Self {
        var result = self
        (result.from, result.to) = (to, from)
        result.name = (
            newName.count == 0 ? name + ".reverse" : newName
        )
        result.$isFinished.write { $0 = false }
        return result
    }
    
    public mutating func reversed(newName: String = "") {
        name = (
            newName.count == 0 ? name + ".reverse" : newName
        )
        (from, to) = (to, from)
        $isFinished.write { $0 = false }
    }
    
    public func cleanAndReverse(newName: String = "") -> Self {
        var result = reverse()
        result.reseted()
        return result
    }
    
    public mutating func cleanAndReversed(newName: String = "") {
        reseted()
        reversed()
    }
    
}
