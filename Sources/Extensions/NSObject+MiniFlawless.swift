//
//  NSObject+MiniFlawless.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/3.
//

import Foundation
import CoreGraphics
import QuartzCore.CADisplayLink

extension NSObject {
    public func miiniFlawless_step(diffCount: CGFloat, duration: CGFloat, framePerSecond: Int) -> CGFloat {
        diffCount / (duration * CGFloat(framePerSecond))
    }
}
