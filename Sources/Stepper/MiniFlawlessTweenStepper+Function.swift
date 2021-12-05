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
        case easeInQuad
        case easeOutQuad
        case easeInOutQuad
        case easeInCubic
        case easeOutCubic
        case easeInOutCubic
        case easeInQuart
        case easeOutQuart
        case easeInOutQuart
        case easeInBounce
        case easeOutBounce
        case easeInExpo
        case easeOutExpo
        case easeInOutExpo
        
        public var value: MiniFlawlessTweenFunctionable.Type {
            switch self {
            case .linear:          return Linear.self
            case .easeInQuad:      return EaseInQuad.self
            case .easeOutQuad:     return EaseOutQuad.self
            case .easeInOutQuad:   return EaseInOutQuad.self
            case .easeInCubic:     return EaseInCubic.self
            case .easeOutCubic:    return EaseOutCubic.self
            case .easeInOutCubic:  return EaseInOutCubic.self
            case .easeInQuart:     return EaseInQuart.self
            case .easeOutQuart:    return EaseOutQuart.self
            case .easeInOutQuart:  return EaseInOutQuart.self
            case .easeInBounce:    return EaseInBounce.self
            case .easeOutBounce:   return EaseOutBounce.self
            case .easeInExpo:      return EaseInExpo.self
            case .easeOutExpo:     return EaseOutExpo.self
            case .easeInOutExpo:   return EaseInOutExpo.self
            }
        }
    }
    
    public struct Linear: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t
        }
    }

    public struct EaseInQuad: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t * t
        }
    }
    
    public struct EaseOutQuad: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t * (2 - t)
        }
    }
    
    public struct EaseInOutQuad: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t < 0.5
                ? ( 2 * t * t )
                : ( -1 + (4 - 2 * t) * t )
        }
    }
    
    public struct EaseInCubic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t * t * t
        }
    }
    
    public struct EaseOutCubic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            pow(t - 1, 3) + 1
        }
    }
    
    public struct EaseInOutCubic: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t < 0.5
                ? ( 4 * pow(t, 3) )
                : ( (t - 1) * pow(2 * t - 2, 2) + 1 )
        }
    }
    
    public struct EaseInQuart: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t * t * t * t
        }
    }
    
    public struct EaseOutQuart: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            1 - pow(t - 1, 4)
        }
    }
    
    public struct EaseInOutQuart: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t < 0.5
                ? ( 8 * pow(t, 4) )
                : ( -1 / 2 * pow(2 * t - 2, 4) + 1 )
        }
    }
    
    public struct EaseInBounce: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            1.0 - EaseOutBounce.step(t: 1.0 - t)
        }
    }
    
    public struct EaseOutBounce: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            if t < 4.0 / 11.0 {
                return pow(11.0 / 4.0, 2) * pow(t, 2)
            }

            if t < 8.0 / 11.0 {
                return 3.0 / 4.0 + pow(11.0 / 4.0, 2) * pow(t - 6.0 / 11.0, 2)
            }

            if t < 10.0 / 11.0 {
                return 15.0 / 16.0 + pow(11.0 / 4.0, 2) * pow(t - 9.0 / 11.0, 2)
            }

            return 63.0 / 64.0 + pow(11.0 / 4.0, 2) * pow(t - 21.0 / 22.0, 2)
        }
    }
    
    public struct EaseInExpo: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t == 0 ? 0.0 : pow(2, 10 * (t - 1))
        }
    }
    
    public struct EaseOutExpo: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            t == 1.0 ? 1 : 1 - pow(2, -10 * t)
        }
    }
    
    public struct EaseInOutExpo: MiniFlawlessTweenFunctionable {
        public static func step(t: TimeInterval) -> TimeInterval {
            if t == 0 { return 0.0 }
            if t == 1 { return 1.0 }
            
            return t < 0.5
                ? ( pow(2, 10 * (2 * t - 1)) / 2 )
                : ( 1 - pow(2, -10 * (2 * t - 1)) / 2 )
        }
    }
    
}
