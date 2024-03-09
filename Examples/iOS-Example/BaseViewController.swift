//
//  BaseViewController.swift
//  iOS-Example
//
//  Created by windy on 2024/3/9.
//

import UIKit
import MiniFlawless

class BaseViewController: UIViewController {
    
    var testView: UIView = .init(frame: .init(x: 0, y: 10, width: 50, height: 50))
    
    var mini: MiniFlawless<CGFloat>!
    
    var isAutoReverse: Bool {
        get {
            guard mini != nil else { return false }
            return mini.displayItem.isAutoReverse
        }
        set {
            guard mini != nil else { return }
            update {
                mini.displayItem.isAutoReverse = newValue
            }
            
        }
    }
    
    var isInfinite: Bool {
        get {
            guard mini != nil else { return false }
            return mini.displayItem.isForeverRun
        }
        set {
            guard mini != nil else { return }
            update {
                mini.displayItem.isForeverRun = newValue
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    deinit {
        mini.destroyAnimation()
    }
    
    func setup() {
        view.backgroundColor = .darkGray
    }
    
    func layoutTest(_ parent: UIView) {
        testView.center.x = parent.center.x
        testView.backgroundColor = .yellow
        parent.addSubview(testView)
        testView.layer.cornerRadius = testView.frame.width * 0.5
    }
    
    func update(_ closure: () -> Void) {
        let isPlaying = mini.displayItem.isPlaying
        if isPlaying { stop() ; mini.resetAnimation() }
        closure()
        if isPlaying { start() }
    }
    
    func start() {
        mini.startAnimation()
    }
    
    func reverse() {
        mini.forceReversedAnimation()
    }
    
    func stop() {
        mini.stopAnimation()
    }
    
}
