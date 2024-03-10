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
    
    var mini: MiniFlawlessAnimator<CGFloat>!
    
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
        view.backgroundColor = .lightGray
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

extension BaseViewController {
    
    func extractFloat(from string: String) -> Double? {
        extractFloats(from: string).first
    }
    
    func extractFloats(from string: String) -> [Double] {
        let pattern = "(\\d+(\\.\\d+)?)" // 正则表达式模式，匹配浮点数
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
          
        let matches = regex.matches(in: string, range: NSRange(location: 0, length: string.utf16.count))
          
        var floats: [Double] = []
        for match in matches {
            let range = match.range
            let substring = (string as NSString).substring(with: range)
            if let floatValue = Double(substring) {
                floats.append(floatValue)
            }
        }
          
        return floats
    }
    
    func extractInt(from string: String) -> Int? {
        extractInts(from: string).first
    }
    
    func extractInts(from string: String) -> [Int] {
        let pattern = "(\\d+)" // 正则表达式模式，匹配浮点数
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
          
        let matches = regex.matches(in: string, range: NSRange(location: 0, length: string.utf16.count))
          
        var ints: [Int] = []
        for match in matches {
            let range = match.range
            let substring = (string as NSString).substring(with: range)
            if let intValue = Int(substring) {
                ints.append(intValue)
            }
        }
        
        return ints
    }
    
    
}
