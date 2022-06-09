//
//  MiniFlawlessSpringStepper.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/3.
//

import Foundation
import CoreGraphics

open class MiniFlawlessSpringStepper<Element: MiniFlawlessSteppable>: MiniFlawlessStepper<Element> {

    open var configuration: Configuration
    
    public init(configuration: Configuration, from: Element, to: Element) {
        self.configuration = configuration
        
        super.init(duration: 0, from: from, to: to)
        
        self.duration = duration(for: configuration.epsilon)
        self.oscillationBlock = oscillation()
        
        self.configuration.update = { [weak self] _ in
            guard let self = self else { return }
            
            self.oscillationBlock = self.oscillation()
        }
        
        self.configuration.durationUpdate = { [weak self] e in
            guard let self = self else { return }
            
            self.duration = self.duration(for: e)
        }
    }
    
    open override func step(t: TimeInterval) -> Element {
        
        let factor = oscillationBlock(t)
        
        let offset = factor --* distance
        
        return from --+ offset
        
    }
    
    /// - Tag: Duration
    
    private func duration(for epsilon: CGFloat) -> TimeInterval {
        
        let beta = configuration.damping / (2 * configuration.mass)
        
        var duration: TimeInterval = 0
        while exp(.init(-beta) * duration) >= .init(epsilon) {
            duration += 0.1
        }

        return duration
    }
    
    /// - Tag: Oscillation
    
    private typealias OscillationBlock = (_ t: TimeInterval) -> TimeInterval
    private var oscillationBlock: OscillationBlock!
    
    private func oscillation() -> OscillationBlock {
        
        let b: TimeInterval  = .init(configuration.damping)
        let m: TimeInterval  = .init(configuration.mass)
        let k: TimeInterval  = .init(configuration.stiffness)
        let v0: TimeInterval = .init(configuration.initialVelocity)

        precondition(m > 0)
        precondition(k > 0)
        precondition(b > 0)

        var beta = b / (2 * m)
        let omega0 = sqrt(k / m)
        let omega1 = sqrt((omega0 * omega0) - (beta * beta))
        let omega2 = sqrt((beta * beta) - (omega0 * omega0))

        let x0: TimeInterval = -1

        if !configuration.allowsOverdamping && beta > omega0 {
            beta = omega0
        }

        if (beta < omega0) {
            // Underdamped
            return { t -> TimeInterval in
                let envelope = exp(-beta * t)

                return -x0 + envelope * (x0 * cos(omega1 * t) + ((beta * x0 + v0) / omega1) * sin(omega1 * t))
            }
        } else if (beta == omega0) {
            // Critically damped
            return { t -> TimeInterval in
                let envelope = exp(-beta * t)

                return -x0 + envelope * (x0 + (beta * x0 + v0) * t)
            }
        } else {
            // Overdamped
            return { t -> TimeInterval in
                let envelope = exp(-beta * t)

                return -x0 + envelope * (x0 * cosh(omega2 * t) + ((beta * x0 + v0) / omega2) * sinh(omega2 * t))
            }
        }
        
    }
    
}

extension MiniFlawlessSpringStepper {
    public struct Configuration {
        
        /// Defines how the spring’s motion should be damped due to the forces of friction.
        public var damping: CGFloat = 10 {
            didSet {
                update(self)
                durationUpdate(epsilon)
            }
        }
        
        /// The mass of the object attached to the end of the spring.
        public var mass: CGFloat = 1 {
            didSet {
                update(self)
                durationUpdate(epsilon)
            }
        }
        
        /// The spring stiffness coefficient.
        public var stiffness: CGFloat = 100 {
            didSet {
                update(self)
//                durationUpdate(epsilon)
            }
        }
        
        /// The initial velocity of the object attached to the spring.
        public var initialVelocity: CGFloat = 0 {
            didSet { update(self) }
        }
        
        public var epsilon: CGFloat = 0.01 {
           didSet { durationUpdate(epsilon) }
        }

        public var allowsOverdamping: Bool = false {
            didSet { update(self) }
        }
        
        internal var update: (Self) -> Void = { _ in  }
        internal var durationUpdate: (_ epsilon: CGFloat) -> Void = { _ in }
        
        public init(damping: CGFloat = 10, mass: CGFloat = 1, stiffness: CGFloat = 100, initialVelocity: CGFloat = 0, epsilon: CGFloat = 0.01, allowsOverdamping: Bool = false)
        {
            self.damping = damping
            self.mass = mass
            self.stiffness = stiffness
            self.initialVelocity = initialVelocity
            self.epsilon = epsilon
            self.allowsOverdamping = allowsOverdamping
        }
        
    }
}
