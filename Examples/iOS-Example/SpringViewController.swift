//
//  SpringViewController.swift
//  iOS-Example
//
//  Created by windy on 2024/3/9.
//

import UIKit
import MiniFlawless

class SpringViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var durationInput: UITextField!
    
    @IBOutlet weak var repeatCountInput: UITextField!
    
    @IBOutlet weak var dampingInput: UITextField!
    
    @IBOutlet weak var massInput: UITextField!
    
    @IBOutlet weak var stiffnessInput: UITextField!
    
    @IBOutlet weak var initialVelocityInput: UITextField!
    
    @IBOutlet weak var epsilonInput: UITextField!
    
    @IBOutlet weak var overDampingSwitch: UISwitch!
    
    @IBOutlet weak var autoReverseSwitch: UISwitch!
    
    @IBOutlet weak var infiniteSwitch: UISwitch!
    
    
    var damping: CGFloat {
        get {
            guard mini != nil else { return MiniFlawless.SpringDefaults.damping }
            return mini.displayItem.springDamping
        }
        set {
            guard mini != nil else { return }
            update {
                mini.displayItem.springDamping = newValue
            }
            
        }
    }
    
    var mass: CGFloat {
        get {
            guard mini != nil else { return MiniFlawless.SpringDefaults.mass }
            return mini.displayItem.springMass
        }
        set {
            guard mini != nil else { return }
            update {
                mini.displayItem.springMass = newValue
            }
            
        }
    }
    
    var stiffness: CGFloat {
        get {
            guard mini != nil else { return MiniFlawless.SpringDefaults.stiffness }
            return mini.displayItem.springStiffness
        }
        set {
            guard mini != nil else { return }
            update {
                mini.displayItem.springStiffness = newValue
            }
            
        }
    }
    
    var initialVelocity: CGFloat {
        get {
            guard mini != nil else { return MiniFlawless.SpringDefaults.initialVelocity }
            return mini.displayItem.springInitialVelocity
        }
        set {
            guard mini != nil else { return }
            update {
                mini.displayItem.springInitialVelocity = newValue
            }
            
        }
    }
    
    var epsilon: CGFloat {
        get {
            guard mini != nil else { return MiniFlawless.SpringDefaults.epsilon }
            return mini.displayItem.springEpsilon
        }
        set {
            guard mini != nil else { return }
            update {
                mini.displayItem.springEpsilon = newValue
            }
            
        }
    }
    
    var isOverDamping: Bool {
        get {
            guard mini != nil else { return MiniFlawless.SpringDefaults.allowsOverdamping }
            return mini.displayItem.isSpringAllowsOverDamping
        }
        set {
            guard mini != nil else { return }
            update {
                mini.displayItem.isSpringAllowsOverDamping = newValue
            }
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutTest(container)
        
        test()
    }
    
    func getDuration() -> Double {
        guard let value = durationInput.text else { return 1 }
        return extractFloat(from: value) ?? 1
    }
    
    func getRepeatCount() -> Int {
        guard let value = repeatCountInput.text else { return 3 }
        return extractInt(from: value) ?? 3
    }
    
    func getDamping() -> Double {
        guard let value = dampingInput.text else { return 1 }
        return extractFloat(from: value) ?? 1
    }
    
    func getMass() -> Double {
        guard let value = massInput.text else { return 1 }
        return extractFloat(from: value) ?? 1
    }
    
    func getStiffness() -> Double {
        guard let value = stiffnessInput.text else { return 100 }
        return extractFloat(from: value) ?? 100
    }
    
    func getInitialVelocity() -> Double {
        guard let value = initialVelocityInput.text else { return 0 }
        return extractFloat(from: value) ?? 0
    }
    
    func getEpsilon() -> Double {
        guard let value = epsilonInput.text else { return 0.01 }
        return extractFloat(from: value) ?? 0.01
    }

    
    func test() {
        
        let item = MiniFlawlessItem<CGFloat>.init(
            name: "Test",
            duration: getDuration(),
            from: testView.frame.minY,
            to: testView.frame.minY + 130,
            stepper: .spring(
                .init(
                    damping: getDamping(), /// 10,
                    mass: getMass(),
                    stiffness: getStiffness(),
                    initialVelocity: getInitialVelocity(),
                    epsilon: getEpsilon(),
                    allowsOverdamping: overDampingSwitch.isOn
                )
            ),
            isAutoReverse: autoReverseSwitch.isOn,
            isForeverRun: infiniteSwitch.isOn,
            repeatCount: getRepeatCount(),
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
        
        let mini = MiniFlawlessAnimator.init(displayItem: item)
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

// MARK: UITextFieldDelegate
extension SpringViewController {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let string = textField.text else { return }
        
        if textField == durationInput, let value = extractFloat(from: string) {
            mini.displayItem.duration = value
            print("Spring Duration Change: ", value)
        }
        
        if textField == repeatCountInput, let value = extractInt(from: string) {
            mini.displayItem.repeatCount = value
            print("Spring RepeatCount Change: ", value)
        }
        
        if textField == dampingInput, let value = extractFloat(from: string) {
            mini.displayItem.springDamping = value
            print("Spring Damping Change: ", value)
        }
        
        if textField == massInput, let value = extractFloat(from: string) {
            mini.displayItem.springMass = value
            print("Spring Mass Change: ", value)
        }
        
        if textField == stiffnessInput, let value = extractFloat(from: string) {
            mini.displayItem.springStiffness = value
            print("Spring Stiffness Change: ", value)
        }
        
        if textField == initialVelocityInput, let value = extractFloat(from: string) {
            mini.displayItem.springInitialVelocity = value
            print("Spring Initial Velocity Change: ", value)
        }
        
        if textField == epsilonInput, let value = extractFloat(from: string) {
            mini.displayItem.springEpsilon = value
            print("Spring Epsilon Change: ", value)
        }
        
    }
    
}
