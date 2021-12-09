//
//  ViewController.swift
//  iOS-Example
//
//  Created by 黄文飞 on 2021/12/4.
//

import UIKit
import MiniFlawless

class ViewController: UIViewController {
    
    var testView: UIView = .init(frame: .init(x: 0, y: 60, width: 100, height: 100))
    
    func setup() {
        view.backgroundColor = .darkGray
        
        testView.center.x = view.center.x
        testView.backgroundColor = .lightGray
        view.addSubview(testView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
        miniSpringTest()
//        miniTweenTest()
        
    }
    
    #if true
    
    var mini: MiniFlawless<CGFloat>!
    
    func miniTweenTest() {
        
        let item = MiniFlawlessItem<CGFloat>.init(
            name: "Test",
            duration: 1,
            from: testView.frame.minY,
            to: testView.frame.minY + 300,
            stepper: .tween(.init(function: .linear)),
//            isAutoReverse: true,
//            isForeverRun: true,
            repeatCount: 3,
            eachCompletion: { item in
                print("Each Done")
            },
            writeBack: { [weak self] info in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.testView.frame.origin.y = info.current
                    print(#function, "eachProgress:", info.eachProgress, "progress:", info.progress)
                }
            },
            isRemoveOnCompletion: false,
            doneFillMode: .from
        ) { item in
            print("Done")
        }
        
        let mini = MiniFlawless.init(displayItem: item)
        self.mini = mini
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            mini.startAnimation()
        }
        
        #if false
        DispatchQueue.global().asyncAfter(deadline: .now() + 6) {
            print("Reverse .....................")
            mini.reversedAnimation()
        }
        #endif
    }
    
    func miniSpringTest() {
        
        let item = MiniFlawlessItem<CGFloat>.init(
            name: "Test",
            duration: 1,
            from: testView.frame.minY,
            to: testView.frame.minY + 300,
            stepper: .spring(
                .init(
                    damping: 1, /// 10,
                    mass: 1,
                    stiffness: 100,
                    initialVelocity: 0,
                    epsilon: 0.01,
                    allowsOverdamping: true
                )
            ),
            isAutoReverse: true,
//            isForeverRun: true,
//            repeatCount: 3,
            eachCompletion: { item in
                print("Each Done")
            },
            writeBack: { [weak self] info in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.testView.frame.origin.y = info.current
                    print(#function, "eachProgress:", info.eachProgress, "progress:", info.progress)
                }
            },
            isRemoveOnCompletion: false
        ) { item in
            print("Done")
        }
        
        let mini = MiniFlawless.init(displayItem: item)
        self.mini = mini
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            mini.startAnimation()
        }
        
        #if false
        DispatchQueue.global().asyncAfter(deadline: .now() + 6) {
            print("Reverse .....................")
            mini.reversedAnimation()
        }
        #endif
    }
    #endif
    
    #if false
    func itemListLinkTest() {
        print(
            MiniFlawlessItemListLinkContainer<Int>
                .virtualHead()
                .element(8)
                .timeFunction(.tween(.init(function: .linear)))
                .element(13)
                .commit()
                .items
        )
    }
    #endif


}

