//
//  MiniFlawlessTweenStepper+Function.swift
//  MiniFlawless
//
//  Sources: https://github.com/RBBAnimation/blob/master/RBBAnimation/RBBEasingFunction.m
//
//  Created by 黄文飞 on 2021/12/3.
//

import Foundation

public protocol MiniFlawlessTweenFunctionable {
    static func step(t: TimeInterval) -> TimeInterval
}

public struct MiniFlawlessTweenStepperFunction {
    
    public enum Function {
        case linear
        case easeInQuadratic
        case easeOutQuadratic
        case easeInOutQuadratic
        case easeInCubic
        case easeOutCubic
        case easeInOutCubic
        case easeInQuartic
        case easeOutQuartic
        case easeInOutQuartic
        case easeInQuintic
        case easeOutQuintic
        case easeInOutQuintic
        case easeInSine
        case easeOutSine
        case easeInOutSine
        case easeInCircular
        case easeOutCircular
        case easeInOutCircular
        case easeInExponencial
        case easeOutExponencial
        case easeInOutExponencial
        case easeInElastic
        case easeOutElastic
        case easeInOutElastic
        case easeInBack
        case easeOutBack
        case easeInOutBack
        case easeInBounce
        case easeOutBounce
        case easeInOutBounce
        
        public var value: MiniFlawlessTweenFunctionable.Type {
            switch self {
            case .linear:               return Linear.self
            case .easeInQuadratic:      return EaseInQuadratic.self
            case .easeOutQuadratic:     return EaseOutQuadratic.self
            case .easeInOutQuadratic:   return EaseInOutQuadratic.self
            case .easeInCubic:          return EaseInCubic.self
            case .easeOutCubic:         return EaseOutCubic.self
            case .easeInOutCubic:       return EaseInOutCubic.self
            case .easeInQuartic:        return EaseInQuartic.self
            case .easeOutQuartic:       return EaseOutQuartic.self
            case .easeInOutQuartic:     return EaseInOutQuartic.self
            case .easeInQuintic:        return EaseInQuintic.self
            case .easeOutQuintic:       return EaseOutQuintic.self
            case .easeInOutQuintic:     return EaseInOutQuintic.self
            case .easeInSine:           return EaseInSine.self
            case .easeOutSine:          return EaseOutSine.self
            case .easeInOutSine:        return EaseInOutSine.self
            case .easeInCircular:       return EaseInCircular.self
            case .easeOutCircular:      return EaseOutCircular.self
            case .easeInOutCircular:    return EaseInOutCircular.self
            case .easeInExponencial:    return EaseInExponencial.self
            case .easeOutExponencial:   return EaseInExponencial.self
            case .easeInOutExponencial: return EaseInOutExponencial.self
            case .easeInElastic:        return EaseInElastic.self
            case .easeOutElastic:       return EaseOutElastic.self
            case .easeInOutElastic:     return EaseInOutElastic.self
            case .easeInBack:           return EaseInBack.self
            case .easeOutBack:          return EaseOutBack.self
            case .easeInOutBack:        return EaseInOutBack.self
            case .easeInBounce:         return EaseInBounce.self
            case .easeOutBounce:        return EaseOutBounce.self
            case .easeInOutBounce:      return EaseInOutBounce.self
            }
        }
    }
    
    // MARK: - Linear

    /// Returns a `TimeInterval` value part of a **Linear**  rate of change of a parameter over time.
    ///
    /// Modelled after the function:
    ///
    /// y = t
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1
    /// - Returns: A `TimeInterval` value.
    public struct Linear: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t
        }
    }
    
    // MARK: - Quadratic

    /// Returns a `TimeInterval` value part of a **Quadratic Ease-In**  rate of change of a parameter over time.
    ///
    /// Modelled after the function:
    ///
    /// y = t^2
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1
    /// - Returns: A `TimeInterval` value.
    public struct EaseInQuadratic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t * t
        }
    }
    
    /// Returns a `TimeInterval` value part of a **Quadratic Ease-Out**  rate of change of a parameter over time.
    ///
    /// Modelled after the Parabola:
    ///
    /// y = -t^2 + 2t
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseOutQuadratic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            -t * (t - 2)
        }
    }
    
    /// Returns a `TimeInterval` value part of a **Quadratic Ease-InOut**  rate of change of a parameter over time.
    ///
    /// Modelled after the piecewise quadratic:
    ///
    /// y = (1/2)((2t)^2)              [0, 0.5[
    /// y = -(1/2)((2t-1)*(2t-3) - 1)  [0.5, 1]
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInOutQuadratic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            if t < 1 / 2 {
                return 2 * t * t
            } else {
                return (-2 * t * t) + (4 * t) - 1
            }
        }
    }
    
    // MARK: - Cubic
    
    /// Returns a `TimeInterval` value part of a **Cubic Ease-In**  rate of change of a parameter over time.
    ///
    /// Modelled after the cubic function:
    ///
    /// y = t^3
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInCubic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t * t * t
        }
    }
    
    /// Returns a `TimeInterval` value part of a **Cubic Ease-Out**  rate of change of a parameter over time.
    ///
    /// Modelled after the cubic function:
    ///
    /// y = (t - 1)^3 + 1
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseOutCubic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            let p = t - 1
            return  p * p * p + 1
        }
    }
    
    /// Returns a `TimeInterval` value part of a **Cubic Ease-InOut**  rate of change of a parameter over time.
    ///
    /// Modelled after the piecewise cubic function:
    ///
    /// y = 1/2 * ((2t)^3)       in  [0, 0.5[
    /// y = 1/2 * ((2t-2)^3 + 2) in  [0.5, 1]
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInOutCubic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            if t < 1 / 2 {
                return 4 * t * t * t
            } else {
                let f = 2 * t - 2
                return 1 / 2 * f * f * f + 1
            }
        }
    }
    
    // MARK: - Quartic
    
    /// Returns a `TimeInterval` value part of a **Quartic Ease-In**  rate of change of a parameter over time.
    ///
    /// Modelled after the quartic function:
    ///
    /// y =  t^4
    ///
    /// - Parameter x: The FloatingPointvalue for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInQuartic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t * t * t * t
        }
    }
    
    /// Returns a `TimeInterval` value part of a **Quartic Ease-Out** rate of change of a parameter over time.
    ///
    /// Modelled after the quartic function:
    ///
    /// y = 1 - (t - 1)^4
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseOutQuartic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            let f = t - 1
            return f * f * f * (1 - t) + 1
        }
    }
    
    /// Returns a `TimeInterval` value part of a **Quartic Ease-InOut**  rate of change of a parameter over time.
    ///
    /// Modelled after the piecewise quartic function:
    ///
    /// y = (1/2)((2t)^4)        in [0, 0.5[
    /// y = -(1/2)((2t-2)^4 - 2) in [0.5, 1]
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInOutQuartic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            if t < 1 / 2 {
                return 8 * t * t * t * t
            } else {
                let f = t - 1
                return -8 * f * f * f * f + 1
            }
        }
    }
    
    // MARK: - Quintic
    
    /// Returns a `TimeInterval` value part of a **Quintic Ease-In**  rate of change of a parameter over time.
    ///
    /// Modelled after the quintic function:
    ///
    /// y = t^5
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInQuintic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            return t * t * t * t * t
        }
    }
    
    /// Returns a `TimeInterval` value part of a **Quintic Ease-Out**  rate of change of a parameter over time.
    ///
    /// Modelled after the quintic function:
    ///
    /// y = (t - 1)^5 + 1
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseOutQuintic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            let f = t - 1
            return f * f * f * f * f + 1
        }
    }
    
    /// Returns a `TimeInterval` value part of a **Quintic Ease-InOut**  rate of change of a parameter over time.
    ///
    /// Modelled after the piecewise quintic function:
    ///
    /// y = 1/2 * ((2t)^5)       in [0, 0.5[
    /// y = 1/2 * ((2t-2)^5 + 2) in [0.5, 1]
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInOutQuintic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            if t < 1 / 2 {
                return 16 * t * t * t * t * t
            } else {
                let f = 2 * t - 2
                let g = f * f * f * f * f
                return 1 / 2 * g + 1
            }
        }
    }
    
    // MARK: - Sine
    
    /// Returns a floating-point value part of a **Sine Ease-In**  rate of change of a parameter over time.
    ///
    /// Modelled after the function:
    ///
    /// y = sin((t-1) * pi/2) + 1
    ///
    /// - Parameter x: The `TimeInterval` value for the time axis of the function, typically 0 <= x <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInSine: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            sin((t - 1) * TimeInterval.pi / 2) + 1
        }
    }
    
    /// Returns a `TimeInterval` value part of a **Sine Ease-Out**  rate of change of a parameter over time.
    ///
    /// Modelled after the function:
    ///
    /// y = sin(t * pi/2)
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `Real` value.
    public struct EaseOutSine: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            sin(t * TimeInterval.pi / 2)
        }
    }
    
    /// Returns a floating-point value part of a **Sine Ease-InOut**  rate of change of a parameter over time.
    ///
    /// Modelled after the function:
    ///
    /// y = 1/2 * (cos(t * pi) - 1)
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInOutSine: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            1 / 2 * ((1 - cos(t * TimeInterval.pi)))
        }
    }
    
    // MARK: - Circular

    /// Returns a floating-point value part of a **Circular Ease-In**  rate of change of a parameter over time.
    ///
    /// Modelled after:
    ///
    /// y = 1 - sqrt(1-(t^2))
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInCircular: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            1 - sqrt(1 - t * t)
        }
    }
    
    /// Returns a `TimeInterval` value part of a **Circular Ease-Out**  rate of change of a parameter over time.
    ///
    /// Modelled after:
    ///
    /// y =  sqrt((2 - x) * x)
    ///
    /// - Parameter x: The `TimeInterval` value for the time axis of the function, typically 0 <= x <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseOutCircular: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            sqrt((2 - t) * t)
        }
    }
    
    /// Returns a `TimeInterval` value part of a **Circular Ease-InOut**  rate of change of a parameter over time.
    ///
    /// Modelled after the piecewise circular function:
    ///
    /// y = (1/2)(1 - sqrt(1 - 4t^2))           in [0, 0.5[
    /// y = (1/2)(sqrt(-(2t - 3)*(2t - 1)) + 1) in [0.5, 1]
    ///
    /// - Parameter x: The `TimeInterval` value for the time axis of the function, typically 0 <= x <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInOutCircular: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            if t < 1 / 2 {
                let h = 1 - sqrt(1 - 4 * t * t)
                return 1 / 2 * h
            } else {
                let f = 2 * t - 1
                let g = -(2 * t - 3) * f
                let h = sqrt(g)
                return 1 / 2 * (h + 1)
            }
        }
    }
    
    // MARK: - Exponencial

    /// Returns a `TimeInterval` value part of an **Exponential Ease-In**  rate of change of a parameter over time.
    ///
    /// Modelled after the piecewise function:
    ///
    /// y = t when t == 0
    /// y = 2^(10(t - 1)) in ]0, 1]
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInExponencial: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t == 0 ? t : pow(2, 10 * (t - 1))
        }
    }
    
    /// Returns a floating-point value part of an **Exponential Ease-Out**  rate of change of a parameter over time.
    ///
    /// Modelled after the piecewise function:
    ///
    /// y = t when t == 1
    /// y = -2^(-10t) + 1 in [0, 1]
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseOutExponencial: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t == 1 ? t : 1 - pow(2, -10 * t)
        }
    }
    
    /// Returns a floating-point value part of a **Exponential Ease-InOut**  rate of change of a parameter over time.
    ///
    /// Modelled after the piecewise function:
    ///
    /// y = t when t == 0 or t == 1
    /// y = 1/2 * 2^(10(2t - 1))        in [0.0, 0.5]
    /// y = -1/2 * 2^(-10(2t - 1))) + 1 in [0.5, 1]
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInOutExponencial: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            if t == 0 || t == 1 {
                return t
            }

            if t < 1 / 2 {
                return 1 / 2 * pow(2, 20 * t - 10)
            } else {
                let h = pow(2, -20 * t + 10)
                return -1 / 2 * h + 1
            }
        }
    }
    
    // MARK: - Elastic

    /// Returns a `TimeInterval` value part of an **Elastic Ease-In**  rate of change of a parameter over time.
    ///
    /// Modelled after the damped sine wave:
    ///
    /// y = sin(13 pi / 2 * t) * pow(2, 10 * (t - 1))
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInElastic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            sin(13 * TimeInterval.pi / 2 * t) * pow(2, 10 * (t - 1))
        }
    }
    
    /// Returns a `TimeInterval` value part of an **Elastic Ease-Out**  rate of change of a parameter over time.
    ///
    /// Modelled after the damped sine wave:
    ///
    /// y = sin(-13 pi/2 * (t + 1)) * pow(2, -10t) + 1
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseOutElastic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            let f = sin(-13 * TimeInterval.pi / 2 * (t + 1))
            let g = pow(2, -10 * t)
            return f * g + 1
        }
    }
    
    /// Returns a `TimeInterval` value part of an **Elastic Ease-InOut**  rate of change of a parameter over time.
    ///
    /// Modelled after piecewise exponentially-damped sine wave:
    ///
    /// y = 1/2 * sin((13pi/2) * 2*t) * pow(2, 10 * ((2*t) - 1))    in  [0,0.5]
    /// y = 1/2 * (sin(-13pi/2*((2t-1)+1)) * pow(2,-10(2*t-1)) + 2) in  [0.5, 1]
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInOutElastic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            if t < 1 / 2 {
                let f = sin((13 * TimeInterval.pi / 2) * 2 * t)
                let g = pow(2, 10 * ((2 * t) - 1))
                return 1 / 2 * f * g
            } else {
                let h = (2 * t - 1) + 1
                let f = sin(-13 * TimeInterval.pi / 2 * h)
                let g = pow(2, -10 * (2 * t - 1))
                return 1 / 2 * (f * g + 2)
            }
        }
    }
    
    // MARK: - Back

    /// Returns a `TimeInterval` value part of a **Back Ease-In** rate of change of a parameter over time.
    ///
    /// Modelled after the cubic function:
    ///
    /// y = x^3-x * sin(t*pi)
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInBack: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            return t * t * t - t * sin(t * TimeInterval.pi)
        }
    }
    
    /// Returns a `TimeInterval` value part of a **Back Ease-Out** rate of change of a parameter over time.
    ///
    /// Modelled after the cubic function:
    ///
    /// y = 1 + (1.70158 + 1) * pow(t - 1, 3) + 1.70158 * pow(t - 1, 2)
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseOutBack: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            let c = 1.70158
            let f = c + 1
            let g = (t - 1) * (t - 1) * (t - 1)
            let h = (t - 1) * (t - 1)
            let i = f * g
            return 1 + i + c * h
        }
    }
    
    /// Returns a `TimeInterval` value part of a **Back Ease-InOut** rate of change of a parameter over time.
    ///
    /// Modelled after the piecewise cubic function:
    ///
    /// y = 1/2 * ((2t)^3-(2t)*sin(2*t*pi))                             in [0, 0.5]
    /// y = 1/2 * 1-((1-(2*t-1))^3-(1-(2*t-1))*(sin(1-(2*t-1)*pi)))+1/2 in [0.5, 1]
    ///
    /// - Parameter t: The `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInOutBack: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            if t < 1 / 2 {
                let f = 2 * t
                let g = f * f * f - f * sin(f * TimeInterval.pi)
                return 1 / 2 * g
            } else {
                let f = 1 - (2 * t - 1)
                let g = sin(f * TimeInterval.pi)
                let h = f * f * f - f * g
                let i = 1 - h
                return 1 / 2 * i + 1 / 2
            }
        }
    }
    
    // MARK: - Bounce
    
    /// Returns a `TimeInterval` value part of a **Bounce Ease-In** rate of change of a parameter over time.
    ///
    /// Modelled using the 'bounceEaseOut' function.
    ///
    /// - Parameter t: A `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `Real` value.
    public struct EaseInBounce: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            1.0 - EaseOutBounce.step(t: 1.0 - t)
        }
    }
    
    /// Returns a `TimeInterval` value part of a **Bounce Ease-Out** rate of change of a parameter over time.
    ///
    /// Modelled using the mother of all bumpy piecewise functions.
    ///
    /// - Parameter t: A `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseOutBounce: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            if t < 4 / 11 {
                return (121 * t * t) / 16
            } else if t < 8 / 11 {
                let f = (363 / 40) * t * t
                let g = (99 / 10) * t
                return f - g + (17 / 5)
            } else if t < 9 / 10 {
                let f = (4356 / 361) * t * t
                let g = (35442 / 1805) * t
                return  f - g + 16061 / 1805
            } else {
                let f = (54 / 5) * t * t
                return f - ((513 / 25) * t) + 268 / 25
            }
        }
    }

    /// Returns a `TimeInterval` value part of a **Bounce Ease-InOut** rate of change of a parameter over time.
    ///
    /// Modelled using the piecewise function:
    ///
    /// y = 1/2 * bounceEaseIn(2t)               in [0, 0.5]
    /// y = 1/2 * bounceEaseOut(t * 2 - 1) + 1/2 in [0.5, 1]
    ///
    /// - Parameter t: A `TimeInterval` value for the time axis of the function, typically 0 <= t <= 1.
    /// - Returns: A `TimeInterval` value.
    public struct EaseInOutBounce: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            if t < 1 / 2 {
                return 1 / 2 * EaseInBounce.step(t: 2 * t)
            } else {
                let f = 1 / 2 * EaseOutBounce.step(t: t * 2 - 1)
                return f + 1 / 2
            }
        }
    }
    
}
