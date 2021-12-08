//
//  MiniFlawlessItem+State.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/3.
//

import Foundation

public enum MiniFlawlessItemState {
    case pause
    case working
    case stop
    case finish
    
    public var isWorking: Bool {
        self == .working
    }
    
    public var canReset: Bool {
        switch self {
        case .working:
            return false
        case .pause, .stop, .finish:
            return true
        }
    }
    
    public var canReverse: Bool {
        switch self {
        case .working:
            return false
        case .pause, .stop, .finish:
            return true
        }
    }
    
    public var canStart: Bool {
        self != .working
    }
    
    public var canPause: Bool {
        self == .working
    }
    
    public var canResume: Bool {
        canStart
    }
    
    public var shouldRestart: Bool {
        canStart && ( self != .pause )
    }
    
    public var canStop: Bool {
        switch self {
        case .pause, .working:
            return true
        case .stop, .finish:
            return false
        }
    }
}
