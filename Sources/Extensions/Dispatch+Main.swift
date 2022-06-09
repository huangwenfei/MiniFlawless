//
//  Dispatch+Main.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/6.
//

import Foundation

internal func uiThread(delay: TimeInterval = 0, _ closure: @escaping () -> Void) {
    if delay > 0 {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    } else {
        DispatchQueue.main.async {
            closure()
        }
    }
}

internal func globalThread(delay: TimeInterval = 0, _ closure: @escaping () -> Void) {
    if delay > 0 {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            closure()
        }
    } else {
        DispatchQueue.global().async {
            closure()
        }
    }
}
