//
//  MiniFlawlessGroup.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/3.
//

import Foundation
import CoreGraphics
import QuartzCore.CADisplayLink

public final class MiniFlawlessGroup<Element: MiniFlawlessSteppable> {
    
    public var displayLink: CADisplayLink? = nil
    
    public var displayActions: MiniFlawlessSignals = .init()
    
    /// `AnimationItem` -> `AnimationItem<CGFloat>`
    /// 正常的 struct 是值类型，变成泛型后 struct 就成了 类对象
    public var displayItems: [MiniFlawlessItem<Element>] = []
    
    private var displayCurrentItems: [MiniFlawlessItem<Element>] = []
    
    @objc private func objc_display(displayLink: CADisplayLink) {
        guard displayCurrentItems.count != 0 else { return }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        // TODO: Time Create
        #warning("Time Create")
        let time = CACurrentMediaTime()
        
        for idx in 0 ..< displayCurrentItems.count {
            /// step function [effect]
            displayCurrentItems[idx].$current.write {
                $0 --+= displayCurrentItems[idx].stepper.step(t: time)
            }
            /// write back
            displayCurrentItems[idx].write()
            /// isDone & Completion & isRemoveOnCompletion
            let item = displayCurrentItems[idx]
//            print(#function, CACurrentMediaTime(), item.current)
            if item.isDone {
//                print(#function, "\(item.name) isDone")
                DispatchQueue.main.async {
                    item.completion?(item)
                }
                if item.isRemoveOnCompletion {
                    displayItems.remove(at: idx)
                }
            }
        }
        /// delete `isDone == true`
        displayCurrentItems = displayCurrentItems.filter {
            $0.isDone == false
        }
        if displayCurrentItems.count == 0 { stopAnimation() }
        CATransaction.commit()
    }
    
    public static var framesPerSecond: Int { 60 }
    public func initDisplayLink() {
        guard displayLink == nil else { return }
        displayLink = CADisplayLink(
            target: self,
            selector: #selector(objc_display(displayLink:))
        )
        displayLink?.add(to: .current, forMode: .common)
        if #available(iOS 10.0, *) {
            /// 0: max refresh rate
            displayLink?.preferredFramesPerSecond = Self.framesPerSecond
        } else {
            /// default value, normal rate
            displayLink?.frameInterval = 1
        }
        displayLink?.isPaused = true
    }
    
    public func deinitDisplayLink() {
        displayLink?.isPaused = true
        displayLink?.invalidate()
        displayLink = nil
    }
    
    public func animateInit() {
        initDisplayLink()
    }
    
    public func animateDeinit() {
        deinitDisplayLink()
        displayItems = []
        displayCurrentItems = []
        displayActions.clean()
    }
    
}

extension MiniFlawlessGroup {
    
    public func startAnimation() {
        guard let link = displayLink else { return }
        
        displayCurrentItems = displayItems
        updateState(with: .willStart)
        displayLink?.isPaused = false
        updateState(with: .start)
        displayActions.start?(link)
    }
    
    public func pauseAnimation() {
        guard let link = displayLink else { return }
        
        displayLink?.isPaused = true
        updateState(with: .pause)
        displayActions.pause?(link)
    }
    
    public func resumeAnimation() {
        guard let link = displayLink else { return }
        
        displayLink?.isPaused = false
        displayActions.resume?(link)
    }
    
    public func stopAnimation() {
        displayLink?.isPaused = true
        guard let link = displayLink else { return }
        displayActions.stop?(link)
    }
    
    public func cleanAnimation() {
        stopAnimation()
        displayItems = []
        displayCurrentItems = []
    }
    
    public func destroyAnimation() {
        cleanAnimation()
        displayActions = MiniFlawlessSignals()
    }
    
    
    private func updateState(with state: MiniFlawlessItemState) {
//        for idx in 0 ..< displayCurrentItems.count {
//            displayCurrentItems[idx].$state.write {
//                $0 = state
//            }
//        }
    }
    
}
