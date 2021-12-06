//
//  MiniFlawless.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/3.
//

import UIKit
import QuartzCore

/// 管理 DisplayLink 和 一个 Item 的动画过程
public final class MiniFlawless<Element: MiniFlawlessSteppable> {
    
    public var displayLink: CADisplayLink? = nil
    public var displayActions: MiniFlawlessSignals = .init()
    
    /// `AnimationItem` -> `AnimationItem<CGFloat>`
    /// 正常的 struct 是值类型，变成泛型后 struct 就成了 类对象
    public var displayItem: MiniFlawlessItem<Element>!
    
    public init(displayItem: MiniFlawlessItem<Element>) {
        self.displayItem = displayItem
        initDisplayLink()
    }
    
    deinit {
        deinitDisplayLink()
        displayItem = nil
        displayActions.clean()
    }
    
    @objc private func objc_display(displayLink: CADisplayLink) {
        guard
            let item = displayItem,
            !item.isDone
        else {
            #if DEBUG
            print(#function, "Display Done !!!")
            #endif
            return
        }
        
        print(#function, displayLink.duration, displayLink.timestamp, displayLink.targetTimestamp)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
//        displayItem.$currentTime.write {
//            $0 += displayLink.duration
//        }
        
        displayItem.updateCurrentTime(by: displayLink.duration)
        
        let currentTime = displayItem.currentTime
        
        #if DEBUG
        print(#function, "EachCurrentTime:", displayItem.eachCurrentTime, "CurrentTime:", currentTime)
        #endif

//        displayItem.$current.write {
//            $0 = item.stepper.step(t: currentTime)
//        }
        
        displayItem.updateCurrent()
        
        #if DEBUG
        print(#function, "CurrentValue:", displayItem.current, "CurrentTime:", currentTime)
        #endif
        
        /// write back
        displayItem.write()
        
        /// isEachDone & eachCompletion
        if !displayItem.isDone && displayItem.isEachDone {
            displayItem.updateRunCount()
            print(#function, "RunCount:", displayItem.currentRunCount)
            DispatchQueue.main.async {
                
                self.displayItem.eachCompletIt()
                
                let future = self.displayItem.isForeverRun
                let reverse = self.displayItem.isAutoReverse
                
                if future || reverse {
                    self.displayLink?.isPaused = true
                    if reverse {
                        self.displayItem.reversed()
                    } else if future {
                        self.displayItem.futureReseted()
                    }
                    self.displayLink?.isPaused = false
                }
            }
        }
        
        /// isDone & Completion & isRemoveOnCompletion
        if displayItem.isDone {
            displayItem.updateRunCount()
            print(#function, "RunCount:", displayItem.currentRunCount)
            DispatchQueue.main.async {
                self.displayItem.completeIt()
                self.stopAnimation()
                if self.displayItem.isRemoveOnCompletion {
                    self.displayItem = nil
                }
            }
        }
        
        CATransaction.commit()
        
    }
    
    public static var framesPerSecond: Int { 60 }
    internal func initDisplayLink() {
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
    
    internal func deinitDisplayLink() {
        displayLink?.isPaused = true
        displayLink?.invalidate()
        displayLink = nil
    }
    
}

extension MiniFlawless {
    
    public func reversedAnimation(delay: TimeInterval = 0) {
        guard displayLink != nil else { return }
        guard displayItem != nil else { return }
        
        displayItem.cleanAndReversed()
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            self.startAnimation()
        }
        
    }
    
    public func startAnimation() {
        guard let link = displayLink else { return }
        guard displayItem != nil else { return }
        
        displayItem.startWrite()
        
//        displayItem.$state.write { $0 = .willStart }
        displayLink?.isPaused = false
//        displayItem.$state.write { $0 = .start }
        displayActions.start?(link)
    }
    
    public func pauseAnimation() {
        guard let link = displayLink else { return }
        guard displayItem != nil else { return }
        
//        displayItem.$state.write { $0 = .willPause }
        displayLink?.isPaused = true
//        displayItem.$state.write { $0 = .pause }
        displayActions.pause?(link)
    }
    
    public func resumeAnimation() {
        guard let link = displayLink else { return }
        guard displayItem != nil else { return }
        
//        displayItem.$state.write { $0 = .willResume }
        displayLink?.isPaused = false
//        displayItem.$state.write { $0 = .resume }
        displayActions.resume?(link)
    }
    
    public func stopAnimation() {
        guard let link = displayLink else { return }
        guard displayItem != nil else { return }
        
//        displayItem.$state.write { $0 = .willStop }
        displayLink?.isPaused = true
//        displayItem.$state.write { $0 = .stop }
        displayActions.stop?(link)
    }
    
    public func cleanAnimation() {
        stopAnimation()
        displayItem = nil
    }
    
    public func destroyAnimation() {
        cleanAnimation()
        displayActions.clean()
    }
    
}
