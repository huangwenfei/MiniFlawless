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
        
        #if false && DEBUG
        print(#function, displayLink.duration, displayLink.timestamp, displayLink.targetTimestamp)
        #endif
        
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
        print(#function, "CurrentValue:", displayItem.current)
        #endif
        
        /// write back
        if !displayItem.isDone { displayItem.write() }
        
        /// isEachDone & eachCompletion
        if !displayItem.isDone && displayItem.isEachDone {
            displayItem.updateRunCount()
            #if DEBUG
            print(#function, "RunCount:", displayItem.passRunCount)
            #endif
            uiThread {
                
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
            #if DEBUG
            print(#function, "RunCount:", displayItem.passRunCount)
            #endif
            uiThread {
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
    
    public func reversedAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        guard displayLink != nil else { return }
        guard displayItem != nil else { return }
        
        self.startAnimation(delay: delay) {
            self.displayItem.cleanAndReversed()
            completion?()
        }
        
    }
    
    public func startAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        guard let link = displayLink else { return }
        guard displayItem != nil else { return }
        
        func working() {
            
            displayItem.reseted()
            displayItem.startWrite()
            
    //        displayItem.$state.write { $0 = .willStart }
            displayLink?.isPaused = false
    //        displayItem.$state.write { $0 = .start }
            
            uiThread {
                self.displayActions.start?(link)
                completion?()
            }
            
        }
        
        if delay > 0 {
            globalThread(delay: delay) { working() }
        } else {
            working()
        }
        
    }
    
    public func pauseAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        guard let link = displayLink else { return }
        guard displayItem != nil else { return }
        
        func working() {
            
//            displayItem.$state.write { $0 = .willPause }
            displayLink?.isPaused = true
//            displayItem.$state.write { $0 = .pause }
            uiThread {
                self.displayActions.pause?(link)
                completion?()
            }
            
        }
        
        if delay > 0 {
            globalThread(delay: delay) { working() }
        } else {
            working()
        }
    }
    
    public func resumeAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        guard let link = displayLink else { return }
        guard displayItem != nil else { return }
        
        func working() {
    //        displayItem.$state.write { $0 = .willResume }
            displayLink?.isPaused = false
    //        displayItem.$state.write { $0 = .resume }
            uiThread {
                self.displayActions.resume?(link)
                completion?()
            }
            
        }
        
        if delay > 0 {
            globalThread(delay: delay) { working() }
        } else {
            working()
        }
    }
    
    public func stopAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        guard let link = displayLink else { return }
        guard displayItem != nil else { return }
        
        func working() {
            
    //        displayItem.$state.write { $0 = .willStop }
            displayLink?.isPaused = true
    //        displayItem.$state.write { $0 = .stop }
            
            displayItem.reseted()
            
            uiThread {
                self.displayActions.stop?(link)
                completion?()
            }
            
        }
        
        if delay > 0 {
            globalThread(delay: delay) { working() }
        } else {
            working()
        }
    }
    
    public func cleanAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        stopAnimation(delay: delay) {
            self.displayItem = nil
            completion?()
        }
    }
    
    public func destroyAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        cleanAnimation(delay: delay) {
            self.displayActions.clean()
            completion?()
        }
    }
    
}
