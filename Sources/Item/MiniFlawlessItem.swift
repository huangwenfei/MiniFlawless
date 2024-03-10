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
    
    @Protected
    public private(set) var state: MiniFlawlessItemState = .stop
    
    public var isFinished: Bool {
        state == .finish
    }
    
    /// Each Duration Or Total Duration
    @Protected
    public var duration: TimeInterval = 0 {
        mutating didSet {
            updatetDurations(by: stepperMode)
        }
    }
    
    public private(set) var eachDuration: TimeInterval = 0
    
    public private(set) var totalDuration: TimeInterval = 0
    
    public var from: Element = .zero {
        didSet {
            $current.write {
                $0 = from
                
                switch stepperMode {
                case .spring, .tween: stepper.from = from
                case .mechanics(let info):
                    switch info.mode {
                    case .deceleration: stepper.from = from
                    case .dampedSpring: break
                    }
                }
            }
        }
    }
    
    public var to: Element = .zero {
        didSet {
            switch stepperMode {
            case .spring, .tween: stepper.to = to
            case .mechanics:      break
            }
        }
    }
    
    public private(set) var stepperMode: AnyStepperConfiguration<Element>.Mode = .tween(.linear)
    
    public private(set) var stepper: MiniFlawlessStepper<Element> = .init(
        duration: 0, from: .zero, to: .zero
    )
    
    /// only vaild when stepper == MechanicsStepper and MechanicsStepper.mode == .deceleration
    
    public typealias Deceleration = MiniFlawlessMechanicsStepper<Element>.Deceleration
    
    public func decelerationDuration(to value: Element) -> TimeInterval? {
        guard let deceleration = (stepper as? MiniFlawlessMechanicsStepper<Element>)?.deceleration else {
            return nil
        }
        
        return deceleration.duration(to: value)
    }
    
    public func decelerationVelocity(at time: TimeInterval) -> Element {
        guard let deceleration = (stepper as? MiniFlawlessMechanicsStepper<Element>)?.deceleration else {
            return .zero
        }
        
        return deceleration.velocity(at: time)
    }
    
    /// - Tag: Write Back
    
    public struct CurrentInfo {
        public var current: Element = .zero
        public var eachProgress: TimeInterval = 0
        public var progress: TimeInterval = 0
        
        public init(current: Element = .zero, eachProgress: TimeInterval = 0, progress: TimeInterval = 0) {
            self.current = current
            self.eachProgress = eachProgress
            self.progress = progress
        }
    }
    
    public typealias WriteBack = (_ currentInfo: CurrentInfo) -> Void
    
    public var writeBack: WriteBack? = nil
    
    public func startWrite() {
        self.writeBack?(
            .init(current: from, eachProgress: 0, progress: 0)
        )
    }
    
    public func write() {
        guard state == .working else { return }
        
        self.writeBack?(
            .init(
                current: current,
                eachProgress: eachProgress,
                progress: progress
            )
        )
    }
    
    /// - Tag: Progress
    
    public var eachProgress: TimeInterval {
        #if false && DEBUG
        print(#function, eachCurrentTime, eachDuration, currentTime, passRunCount)
        #endif
        return min(max(eachCurrentTime / eachDuration, 0), 1)
    }
    
    public var progress: TimeInterval {
        min(max(currentTime / totalDuration, 0), 1)
    }
    
    public var isPlaying: Bool {
        state.isWorking
    }
    
    /// - Tag: Completion
    
    /// Only vaild in Item troup .
    public var isRemoveOnCompletion: Bool = true
    
    public typealias Completion = (Self) -> Void
    public var completion: Completion? = nil
    
    /// 一个运动周期结束后调用
    /// 如： Auto Reverse = true, foreverRun = false, eachCompletion 会被调用一次
    /// 如：repeatCount > 1, foreverRun = false, Auto Reverse = false, eachCompletion 会被调用 repeatCount - 1 次
    /// 如：foreverRun = true, eachCompletion 会被调用 futureCount - 1 次
    public var eachCompletion: Completion? = nil
    
    internal func completeIt() {
        
        defer { completion?(self) }
        
        if doneFillMode != .none {
            
            let isReverse = isAutoReverse && (passRunCount % 2 == 0)
            let from = isReverse ? self.to : self.from
            let to = isReverse ? self.from : self.to
            
            var info = CurrentInfo.init(
                current: .zero,
                eachProgress: 1,
                progress: 1
            )
            
            switch doneFillMode {
            case .none: break
            case .from: info.current = from ; writeBack?(info)
            case .to:   info.current = to   ; writeBack?(info)
            }
        
        }
        
    }
    
    internal func eachCompletIt() {
        eachCompletion?(self)
    }
    
    /// - Tag: Repeat
    
    @Protected
    public var isAutoReverse: Bool = false {
        mutating didSet {
            updatetDurations(by: stepperMode)
        }
    }
    
    @Protected
    public var isForeverRun: Bool = false {
        mutating didSet {
            updatetDurations(by: stepperMode)
        }
    }
    
    @Protected
    public var repeatCount: Int = 0 {
        mutating didSet {
            updatetDurations(by: stepperMode)
        }
    }
    
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
    public internal(set) var current: Element = .zero
    
    @Protected
    public internal(set) var currentTime: TimeInterval = 0
    
    @Protected
    public internal(set) var eachCurrentTime: TimeInterval = 0
    
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
    
    public var isEachDone: Bool {
        eachCurrentTime >= eachDuration
    }
    
    public var isVaild: Bool {
        totalDuration > 0
    }
    
    public var isDone: Bool {
        currentTime >= totalDuration
    }
    
    /// - Tag: Init
    
    public init(name: String = "", duration: TimeInterval, from: Element, to: Element, stepper: AnyStepperConfiguration<Element>.Mode, isAutoReverse: Bool = false, isForeverRun: Bool = false, repeatCount: Int = 1, eachCompletion: Completion? = nil, writeBack: WriteBack? = nil, isRemoveOnCompletion: Bool = false, doneFillMode: MiniFlawlessItemFillMode = .none, completion: Completion? = nil) {
        
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
        updatetDurations(by: stepper)
        
    }
    
    public init(mechanicsWithName name: String = "", stepper: MiniFlawlessMechanicsStepper<Element>.Configuration, isAutoReverse: Bool = false, isForeverRun: Bool = false, repeatCount: Int = 1, eachCompletion: Completion? = nil, writeBack: WriteBack? = nil, isRemoveOnCompletion: Bool = false, doneFillMode: MiniFlawlessItemFillMode = .none, completion: Completion? = nil) {
        
        self.name = name
        self.isAutoReverse = isAutoReverse
        self.isForeverRun = isForeverRun
        self.repeatCount = repeatCount
        self.eachCompletion = eachCompletion
        self.writeBack = writeBack
        self.isRemoveOnCompletion = isRemoveOnCompletion
        self.doneFillMode = doneFillMode
        self.completion = completion
        
        updateStepper(by: .mechanics(stepper))
        updatetDurations(by: .mechanics(stepper))
        
    }
    
    /// - Tag: Update
    
    public mutating func updateStepper(by new: AnyStepperConfiguration<Element>.Mode) {
        
        self.stepperMode = new
        
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
            
        case let .mechanics(configs):
            stepper = MiniFlawlessMechanicsStepper<Element>.init(
                configuration: configs
            )
            
            self.duration = stepper.duration
            self.from = stepper.from
            self.to = stepper.to
            self.current = from
            
            #if false && DEBUG
            print(Self.self, #function, #line, configs.description, "F: \(from) - D: \(duration) - T: \(to)")
            #endif
            
        }
    }
    
    private mutating func updatetDurations(by new: AnyStepperConfiguration<Element>.Mode) {
        
        let duration: TimeInterval
        switch new {
        case .spring:
            duration = stepper.duration
            eachDuration = duration * (isAutoReverse ? 2 : 1)
            
        case .tween:
            duration = self.duration < 0 ? 0.25 : self.duration
            eachDuration = duration * (isAutoReverse ? 0.5 : 1)
            
        case .mechanics:
            duration = stepper.duration
            eachDuration = duration * (isAutoReverse ? 2 : 1)
        }
        
        totalDuration = eachDuration * .init(runCount)
        
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
        return result
    }
    
    public mutating func reseted() {
        $current.write { $0 = from }
        $currentTime.write { $0 = 0 }
        $eachCurrentTime.write { $0 = 0 }
        $passRunCount.write { $0 = 0 }
    }
    
    /// - Tag: Reverse
    
    public func reverse(newName: String = "") -> Self {
        var result = self
        (result.from, result.to) = (to, from)
        result.name = (
            newName.count == 0 ? name + ".reverse" : newName
        )
        return result
    }
    
    public mutating func reversed(newName: String = "") {
        name = (
            newName.count == 0 ? name + ".reverse" : newName
        )
        (from, to) = (to, from)
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

// MARK: Spring Only
public typealias SpringDefaults = MiniFlawlessSpringStepperConfiguration.Defaults

extension MiniFlawlessItem {
    
    public var springDamping: CGFloat {
        get {
            switch stepperMode {
            case .spring(let configs):
                return configs.damping
                
            default:
                return SpringDefaults.damping
            }
        }
        set {
            switch stepperMode {
            case .spring(let configs):
                var new = configs
                new.damping = newValue
                updateStepper(by: .spring(new))
                
            default:
                break
            }
        }
    }
    
    public var springMass: CGFloat {
        get {
            switch stepperMode {
            case .spring(let configs):
                return configs.mass
                
            default:
                return SpringDefaults.mass
            }
        }
        set {
            switch stepperMode {
            case .spring(let configs):
                var new = configs
                new.mass = newValue
                updateStepper(by: .spring(new))
                
            default:
                break
            }
        }
    }
    
    public var springStiffness: CGFloat {
        get {
            switch stepperMode {
            case .spring(let configs):
                return configs.stiffness
                
            default:
                return SpringDefaults.stiffness
            }
        }
        set {
            switch stepperMode {
            case .spring(let configs):
                var new = configs
                new.stiffness = newValue
                updateStepper(by: .spring(new))
                
            default:
                break
            }
        }
    }
    
    public var springInitialVelocity: CGFloat {
        get {
            switch stepperMode {
            case .spring(let configs):
                return configs.initialVelocity
                
            default:
                return SpringDefaults.initialVelocity
            }
        }
        set {
            switch stepperMode {
            case .spring(let configs):
                var new = configs
                new.initialVelocity = newValue
                updateStepper(by: .spring(new))
                
            default:
                break
            }
        }
    }
    
    public var springEpsilon: CGFloat {
        get {
            switch stepperMode {
            case .spring(let configs):
                return configs.epsilon
                
            default:
                return SpringDefaults.epsilon
            }
        }
        set {
            switch stepperMode {
            case .spring(let configs):
                var new = configs
                new.epsilon = newValue
                updateStepper(by: .spring(new))
                
            default:
                break
            }
        }
    }
    
    public var isSpringAllowsOverDamping: Bool {
        get {
            switch stepperMode {
            case .spring(let configs):
                return configs.allowsOverdamping
                
            default:
                return SpringDefaults.allowsOverdamping
            }
        }
        set {
            switch stepperMode {
            case .spring(let configs):
                var new = configs
                new.allowsOverdamping = newValue
                updateStepper(by: .spring(new))
                
            default:
                break
            }
        }
    }
    
}
