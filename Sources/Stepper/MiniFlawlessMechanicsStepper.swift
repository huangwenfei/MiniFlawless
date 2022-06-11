//
//  MiniFlawlessMechanicsStepper.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2022/6/5.
//

import Foundation
import CoreGraphics

public protocol MiniFlawlessMechanicsFunction {
    associatedtype Value: MiniFlawlessMechanicsSteppable
    
    var duration: TimeInterval { get }
    var from: Value { get }
    var to: Value { get }
    
    func current(at time: TimeInterval) -> Value
    
}

public protocol MiniFlawlessMechanicsSteppable {
    
    var length: Double { get }
    
    func distance(toSegment segment: (from: Self, to: Self)) -> Double
    
}

open class MiniFlawlessMechanicsStepper<Element: MiniFlawlessSteppable>: MiniFlawlessStepper<Element> {
    
    open var configuration: Configuration
    
    open var deceleration: Deceleration? = nil
    
    open var criticallyDampedSpring: CriticallyDampedSpring? = nil
    open var underdampedSpring: UnderdampedSpring? = nil
    
    public init(configuration: Configuration) {
        
        self.configuration = configuration
        
        let duration: TimeInterval
        let from: Element
        let to: Element
        
        switch configuration.mode {
        case let .deceleration(info):
            deceleration = info
            
            duration = info.limitDuration
            from = info.from
            to = info.to
            
            #if false && DEBUG
            print(Self.self, #function, #line, info.description, "F: \(from) - D: \(info.limitDuration) - LD:\(info.duration) - T: \(to)")
            #endif
            
        case let .dampedSpring(info):
            
            if info.isUsingCritically {
                
                let spring = CriticallyDampedSpring(spring: info)
                criticallyDampedSpring = spring
                
                duration = spring.duration
                from = spring.from
                to = spring.to
                
                #if false && DEBUG
                print(Self.self, #function, #line, info.description, "F: \(from) - D: \(duration) - T: \(to)")
                #endif
                
            } else {
                
                let spring = UnderdampedSpring(spring: info)
                underdampedSpring = spring
                
                duration = spring.duration
                from = spring.from
                to = spring.to
                
                #if false && DEBUG
                print(Self.self, #function, #line, info.description, "F: \(from) - D: \(duration) - T: \(to)")
                #endif
                
            }
            
        }
        
        super.init(duration: duration, from: from, to: to)
    }
    
    open override func step(t: TimeInterval) -> Element {
             
        let time = min(max(0, t), duration)
        
        switch configuration.mode {
        case .deceleration:
            return deceleration!.current(at: time)
            
        case let .dampedSpring(info):
            return info.isUsingCritically
                ? info.displacementOffset --+ criticallyDampedSpring!.current(at: time)
                : info.displacementOffset --+ underdampedSpring!.current(at: time)
        }
        
    }
    
}

extension MiniFlawlessMechanicsStepper {
    
    public struct Configuration: CustomStringConvertible {
        
        public var mode: Mode = .deceleration(.init())
        
        public init(mode: Mode = .deceleration(.init())) {
            self.mode = mode
        }
        
        public var description: String {
            switch mode {
            case .deceleration(let configs):
                return configs.description
            case .dampedSpring(let configs):
                return configs.description
            }
        }
        
    }
    
    public enum Mode {
        case deceleration(Deceleration)
        case dampedSpring(DampedSpring)
    }
    
    public struct Deceleration: MiniFlawlessMechanicsFunction, CustomStringConvertible {
        
        public var initialValue: Element
        public var destinationLimit: Element?
        public var durationMax: TimeInterval?
        public var initialVelocity: Element
        public var decelerationRate: Double
        public var threshold: Double
        
        public var description: String {
            """
            \(Self.self) {
                initialValue: \(initialValue),
                destinationLimit: \(String(describing: destinationLimit)),
                durationMax: \(String(describing: durationMax)),
                initialVelocity: \(initialVelocity),
                decelerationRate: \(decelerationRate),
                threshold: \(threshold)
            }
            """
        }
        
        public init(initialValue: Element = .zero, initialVelocity: Element = .zero, destinationLimit: Element? = nil, durationMax: TimeInterval? = nil, decelerationRate: Double = 0.998, threshold: Double = .zero) {
            
            assert(decelerationRate > 0 && decelerationRate < 1)
            
            self.initialValue = initialValue
            self.destinationLimit = destinationLimit
            self.durationMax = durationMax
            self.initialVelocity = initialVelocity
            self.decelerationRate = decelerationRate
            self.threshold = threshold
        }
        
        public init(other: Self) {
            
            assert(other.decelerationRate > 0 && other.decelerationRate < 1)
            
            self.initialValue = other.initialValue
            self.destinationLimit = other.destinationLimit
            self.durationMax = other.durationMax
            self.initialVelocity = other.initialVelocity
            self.decelerationRate = other.decelerationRate
            self.threshold = other.threshold
        }
        
        /// - Tag: MiniFlawlessMechanicsFunction
        
        public typealias Value = Element
        
        public var limitDuration: TimeInterval {
            
            let duration = self.duration
            
            guard let destinationLimit = destinationLimit else {
                return duration
            }

            let dCoeff = 1000 * log(decelerationRate)
            return TimeInterval(log(1.0 + dCoeff * (destinationLimit --- initialValue).length / initialVelocity.length) / dCoeff)
        }
        
        public var duration: TimeInterval {
            guard initialVelocity.length > 0 else { return 0 }
            
            let dCoeff = 1000 * log(decelerationRate)
            let result = TimeInterval(log(-dCoeff * threshold / initialVelocity.length) / dCoeff)
            
            if let durationMax = durationMax {
                return min(result, durationMax)
            } else {
                return result
            }
        }
        
        public func current(at time: TimeInterval) -> Value {
            let dCoeff = 1000 * log(decelerationRate)
            return from --+ (pow(decelerationRate, Double(1000 * time)) - 1) / dCoeff --* initialVelocity
        }
        
        public var from: Value {
            get { initialValue }
            set { initialValue = newValue }
        }
        
        public var to: Value {
            let dCoeff = 1000 * log(decelerationRate)
            return from --- initialVelocity --/ dCoeff
        }

        public func duration(to value: Value) -> TimeInterval? {
            guard value.distance(toSegment: (from, to)) < threshold else { return nil }

            let dCoeff = 1000 * log(decelerationRate)
            return TimeInterval(log(1.0 + dCoeff * (value --- from).length / initialVelocity.length) / dCoeff)
        }
        
        public func velocity(at time: TimeInterval) -> Element {
            return initialVelocity --* pow(decelerationRate, Double(1000 * time))
        }
        
    }
    
    public struct DampedSpring: CustomStringConvertible {
        
        public var spring: Spring
        public var displacement: Element
        public var displacementOffset: Element
        public var initialVelocity: Element
        public var threshold: Double
        
        public var description: String {
            """
            \(Self.self) {
                spring: \(spring),
                displacement: \(displacement),
                displacementOffset: \(displacementOffset),
                initialVelocity: \(initialVelocity),
                threshold: \(threshold)
            }
            """
        }
        
        public init(spring: Spring = .init(), displacement: Element = .zero, displacementOffset: Element = .zero, initialVelocity: Element = .zero, threshold: Double = 0) {
            
            self.spring = spring
            self.displacement = displacement
            self.displacementOffset = displacementOffset
            self.initialVelocity = initialVelocity
            self.threshold = threshold
        }
        
        public init(other: Self) {
            self.spring = other.spring
            self.displacement = other.displacement
            self.displacementOffset = other.displacementOffset
            self.initialVelocity = other.initialVelocity
            self.threshold = other.threshold
        }
        
        public var displace: Element {
            displacement --- displacementOffset
        }
        
        public var isUsingCritically: Bool {
            spring.dampingRatio == 1
        }
        
    }
    
    public struct CriticallyDampedSpring: MiniFlawlessMechanicsFunction {
        
        public var spring: DampedSpring
        
        public init(spring: DampedSpring = .init()) {
            self.spring = spring
        }
        
        /// - Tag: MiniFlawlessMechanicsFunction
        
        public typealias Value = Element
        
        public var from: Element {
            current(at: 0) --+ spring.displacementOffset
        }
        
        public var to: Element {
            current(at: 0) --+ spring.displacementOffset
        }
    
        public var duration: TimeInterval {
            if spring.displace.length == 0 && spring.initialVelocity.length == 0 {
                return 0
            }
            
            let b = spring.spring.beta
            let e = Double(M_E)
             
            let t1 = 1 / b * log(2 * c1.length / spring.threshold)
            let t2 = 2 / b * log(4 * c2.length / (e * b * spring.threshold))
            
            return TimeInterval(max(t1, t2))
        }
        
        public func current(at time: TimeInterval) -> Element {
            let t = Double(time)
            return exp(-spring.spring.beta * t) --* (c1 --+ c2 --* t)
        }
        
        public var c1: Value {
            spring.displace
        }
        
        public var c2: Element {
            spring.initialVelocity --+ spring.spring.beta --* spring.displace
        }
        
    }
    
    public struct UnderdampedSpring: MiniFlawlessMechanicsFunction {
        
        public var spring: DampedSpring
        
        public init(spring: DampedSpring = .init()) {
            self.spring = spring
        }
        
        /// - Tag: MiniFlawlessMechanicsFunction
        
        public typealias Value = Element
        
        public var from: Element {
            current(at: 0) --+ spring.displacementOffset
        }
        
        public var to: Element {
            current(at: 0) --+ spring.displacementOffset
        }
        
        public var duration: TimeInterval {
            if spring.displace.length == 0 && spring.initialVelocity.length == 0 {
                return 0
            }
            
            return TimeInterval(log((c1.length + c2.length) / spring.threshold) / spring.spring.beta)
        }
        
        public func current(at time: TimeInterval) -> Element {
            let t = Double(time)
            let wd = spring.spring.dampedNaturalFrequency
            return exp(-spring.spring.beta * t) --* (c1 --* cos(wd * t) --+ c2 --* sin(wd * t))
        }
        
        public var c1: Value {
            spring.displace
        }
        
        public var c2: Element {
            (spring.initialVelocity --+ spring.spring.beta --* spring.displace) --/ spring.spring.dampedNaturalFrequency
        }
        
    }
    
    public struct Spring: CustomStringConvertible {
        
        public var mass: Double
        public var stiffness: Double
        public var dampingRatio: Double
        
        public var description: String {
            """
            \(Self.self) {
                mass: \(mass),
                stiffness: \(stiffness),
                dampingRatio: \(dampingRatio)
            }
            """
        }
        
        public static var `default`: Self { .init() }
        
        public init(mass: Double = 1, stiffness: Double = 200, dampingRatio: Double = 1) {
            self.mass = mass
            self.stiffness = stiffness
            self.dampingRatio = dampingRatio
        }
        
        public var damping: Double {
            return 2 * dampingRatio * sqrt(mass * stiffness)
        }
        
        public var beta: Double {
            return damping / (2 * mass)
        }
        
        public var dampedNaturalFrequency: Double {
            return sqrt(stiffness / mass) * sqrt(1 - dampingRatio * dampingRatio)
        }
        
    }
    
}

