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
    
    public private(set) var displayLink: CADisplayLink? = nil
    
    /// `AnimationItem` -> `AnimationItem<CGFloat>`
    /// 正常的 struct 是值类型，变成泛型后 struct 就成了 类对象
    public var displayItem: MiniFlawlessItem<Element>!
    
    public var framesPerSecond: Int = framesPerSecond
    public static var framesPerSecond: Int { 60 }
    
    public var displayActions: MiniFlawlessSignals<Element>? = nil
    
    public init(displayItem: MiniFlawlessItem<Element>, framesPerSecond: Int = framesPerSecond, displayActions: MiniFlawlessSignals<Element>? = nil) {
        self.framesPerSecond = framesPerSecond
        self.displayItem = displayItem
        self.displayActions = displayActions
        initDisplayLink()
    }
    
    deinit {
        deinitDisplayLink()
        displayItem = nil
        displayActions?.clean()
        displayActions = nil
    }
    
    @objc private func objc_display(displayLink: CADisplayLink) {
        guard
            let item = displayItem,
            item.state == .working
        else {
            #if DEBUG
            print(#function, "Display Done !!!")
            #endif
            self.displayItem.$state.write { $0 = .finish }
            self.displayLink?.isPaused = true
            return
        }
        
        #if false && DEBUG
        print(#function, displayLink.duration, displayLink.timestamp, displayLink.targetTimestamp)
        #endif
        
        /// - Tag: CA Begin
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        /// - Tag: Current Time
        
        displayItem.updateCurrentTime(by: displayLink.duration)
        
        let currentTime = displayItem.currentTime
        
        #if DEBUG
        print(#function, "EachCurrentTime:", displayItem.eachCurrentTime, "CurrentTime:", currentTime)
        #endif
        
        /// - Tag: Current
        
        displayItem.updateCurrent()
        
        #if DEBUG
        print(#function, "CurrentValue:", displayItem.current)
        #endif
        
        /// write back
        if !displayItem.isDone { displayItem.write() }
        
        /// - Tag: Progress Signal
        
        displayActions?.progress?(item, item.eachProgress, item.progress)
        
        /// - Tag: Each Done
        
        /// isEachDone & eachCompletion
        if !displayItem.isDone && displayItem.isEachDone {
            
            displayItem.updateRunCount()
            
            #if DEBUG
            print(#function, "RunCount:", displayItem.passRunCount)
            #endif
            
            self.displayItem.eachCompletIt()
            
            let future = self.displayItem.isForeverRun
            let reverse = self.displayItem.isAutoReverse
            
            if future || reverse {
                if reverse {
                    self.displayItem.reversed()
                } else if future {
                    self.displayItem.futureReseted()
                }
            }
        }
        
        /// - Tag: Done
        
        /// isDone & Completion & isRemoveOnCompletion
        if displayItem.isDone {
            
            /// - Tag: Pause
            self.displayLink?.isPaused = true
            
            /// - Tag: Update Last Count
            displayItem.updateRunCount()
            #if DEBUG
            print(#function, "RunCount:", displayItem.passRunCount)
            #endif
            
            /// - Tag: Set Last State
            self.displayItem.$state.write { $0 = .finish }
            self.displayItem.completeIt()
            
            /// - Tag: Remove On Completion
            if self.displayItem.isRemoveOnCompletion {
                self.displayItem = nil
            }
        }
        
        /// - Tag: CA End
        
        CATransaction.commit()
        
    }
    
    internal func initDisplayLink() {
        guard displayLink == nil else { return }
        displayLink = CADisplayLink(
            target: self,
            selector: #selector(objc_display(displayLink:))
        )
        displayLink?.add(to: .current, forMode: .common)
        if #available(iOS 10.0, *) {
            /// 0: max refresh rate
            displayLink?.preferredFramesPerSecond = framesPerSecond
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
    
    public func resetAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        
        guard displayLink != nil else { return }
        guard let item = displayItem else { return }
        
        guard item.state.canReset else { return }
        
        forceResetAnimation(delay: delay, completion: completion)
        
    }
    
    public func forceResetAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        
        guard displayLink != nil else { return }
        guard let item = displayItem else { return }
        
        func working() {
            
            var isWorking: Bool = false
            displayItem.$state.read { isWorking = $0.isWorking }
            
            if isWorking { self.displayLink?.isPaused = true }
            self.displayItem.reseted()
            self.displayItem.startWrite()
            self.displayActions?.reset?(item)
            if isWorking { self.displayLink?.isPaused = false }
            completion?()
        }
        
        if delay > 0 {
            globalThread(delay: delay) { working() }
        } else {
            working()
        }
        
    }
    
    public func reversedAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        
        guard displayLink != nil else { return }
        guard let item = displayItem else { return }
        
        guard item.state.canReverse else { return }
        
        forceReversedAnimation(delay: delay, completion: completion)
        
    }
    
    public func forceReversedAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        
        guard displayLink != nil else { return }
        guard let item = displayItem else { return }
        
        func working() {
            self.displayLink?.isPaused = true
            self.displayItem.cleanAndReversed()
            self.displayItem.startWrite()
            self.displayActions?.reverse?(item)
            self.displayLink?.isPaused = false
            self.displayItem.$state.write { $0 = .working }
            completion?()
        }
        
        if delay > 0 {
            globalThread(delay: delay) { working() }
        } else {
            working()
        }
        
    }
    
    public func startAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {

        guard displayLink != nil else { return }
        guard let item = displayItem else { return }
        
        #if false && DEBUG
        print(#function, "state:", item.state, "canStart:", item.state.canStart)
        #endif
        
        guard item.state.canStart else { return }
        
        func working() {
            
            #if false && DEBUG
            print(#function, "Start ...")
            #endif
            
            displayItem.reseted()
            displayItem.startWrite()
            
            self.displayLink?.isPaused = false
            self.displayItem.$state.write { $0 = .working }
            self.displayActions?.start?(item)
            completion?()
            
        }
        
        if delay > 0 {
            globalThread(delay: delay) { working() }
        } else {
            working()
        }
        
    }
    
    public func pauseAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        
        guard displayLink != nil else { return }
        guard let item = displayItem else { return }
        
        guard item.state.canPause else { return }
        
        func working() {
    
            self.displayLink?.isPaused = true
            self.displayItem.$state.write { $0 = .pause }
            self.displayActions?.pause?(item)
            completion?()
            
        }
        
        if delay > 0 {
            globalThread(delay: delay) { working() }
        } else {
            working()
        }
    }
    
    public func resumeAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        
        guard displayLink != nil else { return }
        guard let item = displayItem else { return }
        
        guard item.state.canResume else { return }
        
        func working() {
            
            var shouldRestart: Bool = false
            displayItem.$state.read { shouldRestart = $0.shouldRestart }
            
            if shouldRestart {
                displayItem.reseted()
                displayItem.startWrite()
            }
            
            self.displayLink?.isPaused = false
            self.displayItem.$state.write { $0 = .working }
            self.displayActions?.resume?(item)
            completion?()
            
        }
        
        if delay > 0 {
            globalThread(delay: delay) { working() }
        } else {
            working()
        }
    }
    
    public func stopAnimation(delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        
        guard displayLink != nil else { return }
        guard let item = displayItem else { return }
        
        #if false && DEBUG
        print(#function, "state:", item.state, "CanStop:", item.state.canStop)
        #endif
        
        guard item.state.canStop else { return }
        
        func working() {
            
            #if DEBUG
            print(#function, "Stop ...")
            #endif
            
            self.displayLink?.isPaused = true
            self.displayItem.reseted()
            self.displayItem.$state.write { $0 = .stop }
            
            self.displayActions?.stop?(item)
            completion?()
            
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
            self.displayActions?.clean()
            completion?()
        }
    }
    
}
