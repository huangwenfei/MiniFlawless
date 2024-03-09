//
//  SpringViewController.swift
//  iOS-Example
//
//  Created by windy on 2024/3/9.
//

import UIKit
import MiniFlawless

class SpringViewController: BaseViewController {
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var duartionInput: UITextField!
    
    @IBOutlet weak var repeatCountInput: UITextField!
    
    @IBOutlet weak var dampingInput: UITextField!
    
    @IBOutlet weak var massInput: UITextField!
    
    @IBOutlet weak var stiffnessInput: UITextField!
    
    @IBOutlet weak var initialVelocityInput: UITextField!
    
    @IBOutlet weak var epsilonInput: UITextField!
    
    
    var isOverDamping: Bool {
        get {
            guard mini != nil else { return false }
            
            switch mini.displayItem.stepperMode {
            case .spring(let configs):
                return configs.allowsOverdamping
                
            default:
                return false
            }
        }
        set {
            guard mini != nil else { return }
            
            switch mini.displayItem.stepperMode {
            case .spring(let configs):
                var new = configs
                new.allowsOverdamping = newValue
                update {
                    mini.displayItem.updateStepper(by: .spring(new))
                }
                
            default:
                break
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutTest(container)
        
        test()
    }
    
    func test() {
        
        let item = MiniFlawlessItem<CGFloat>.init(
            name: "Test",
            duration: 1,
            from: testView.frame.minY,
            to: testView.frame.minY + 130,
            stepper: .spring(
                .init(
                    damping: 1, /// 10,
                    mass: 1,
                    stiffness: 100,
                    initialVelocity: 0,
                    epsilon: 0.01,
                    allowsOverdamping: isOverDamping
                )
            ),
            isAutoReverse: isAutoReverse,
            isForeverRun: isInfinite,
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

    }
    
    // MAKR: Actions
    
    @IBAction func autoReverse(_ sender: UISwitch) {
        isAutoReverse = sender.isOn
    }
    
    @IBAction func infinite(_ sender: UISwitch) {
        isInfinite = sender.isOn
    }
    
    @IBAction func overDamping(_ sender: UISwitch) {
        isOverDamping = sender.isOn
    }
    
    
    @IBAction func startAction(_ sender: Any) {
        start()
    }
    
    @IBAction func reverseAction(_ sender: Any) {
        reverse()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        stop()
    }
    
}
