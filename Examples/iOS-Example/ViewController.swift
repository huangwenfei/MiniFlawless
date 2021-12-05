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
    
    var mini: MiniFlawless<CGFloat>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .darkGray
        
        testView.center.x = view.center.x
        testView.backgroundColor = .lightGray
        view.addSubview(testView)
        
        let item = MiniFlawlessItem<CGFloat>.init(
            name: "Test",
            duration: 1,
            from: testView.frame.minY,
            to: testView.frame.minY + 300,
            stepper: .tween(.init(function: .linear)),
            isAutoReverse: true,
            isForeverRun: true,
            repeatCount: 3,
            eachCompletion: { item in
                print("Each Done")
            },
            writeBack: { [weak self] in
                guard let self = self else { return }
                self.testView.frame.origin.y = $0
                print(#function, "eachProgress:", $1, "progress:", $2)
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


}
