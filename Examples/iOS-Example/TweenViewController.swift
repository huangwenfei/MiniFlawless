//
//  TweenViewController.swift
//  iOS-Example
//
//  Created by windy on 2024/3/9.
//

import UIKit
import MiniFlawless

class TweenViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var durationInput: UITextField!
    
    @IBOutlet weak var repeatCountInput: UITextField!
    
    @IBOutlet weak var autoReverseSwitch: UISwitch!
    
    @IBOutlet weak var infiniteSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutTest(container)
        
        test()
        
    }
    
    func getDuration() -> Double {
        guard let value = durationInput.text else { return 1.5 }
        return extractFloat(from: value) ?? 1.5
    }
    
    func getRepeatCount() -> Int {
        guard let value = repeatCountInput.text else { return 3 }
        return extractInt(from: value) ?? 3
    }
    
    func test() {
        
        let item = MiniFlawlessItem<CGFloat>.init(
            name: "Test",
            duration: getDuration(),
            from: testView.frame.minY,
            to: testView.frame.minY + 240,
            stepper: .tween(.linear),
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
            isRemoveOnCompletion: false,
            doneFillMode: .from
        ) { item in
            print("Done")
        }
        
        let mini = MiniFlawlessAnimator.init(displayItem: item)
        self.mini = mini

    }
    
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
    
    func miniTweenAlphaTest(isIn: Bool = true) {
        
        let item = MiniFlawlessItem<CGFloat>.init(
            name: "Test Alpha",
            duration: 0.75,
            from: isIn ? 0 : 100,
            to: isIn ? 100 : 0,
            stepper: .tween(isIn ? .easeInBounce : .easeOutBounce),
            writeBack: { info in
                print(info.current)
            },
            isRemoveOnCompletion: false,
            doneFillMode: .none
        )
        
        let mini = MiniFlawlessAnimator.init(displayItem: item, framesPerSecond: 16)
        self.mini = mini
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            mini.startAnimation()
        }
    }
    
    // MARK: Actions
    
    @IBAction func autoReverse(_ sender: UISwitch) {
        isAutoReverse = sender.isOn
    }
    
    @IBAction func infinite(_ sender: UISwitch) {
        isInfinite = sender.isOn
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

// MAKR: UIPickerViewDataSource

extension TweenViewController {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        MiniFlawlessTweenStepperFunction.Function.easeInOutBounce.rawValue + 1
    }
    
}

// MAKR: UIPickerViewDelegate

extension TweenViewController {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        MiniFlawlessTweenStepperFunction.Function(rawValue: row)!.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let function = MiniFlawlessTweenStepperFunction.Function.allCases[row]
        
        let mode = mini.displayItem.stepperMode
        switch mode {
        case .tween:
            update {
                mini.displayItem.updateStepper(by: .tween(.init(function: function)))
            }
            
        default:
            break
        }
        
        print("Function: ", function)
        
    }
    
}

// MARK: UITextFieldDelegate
extension TweenViewController {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let string = textField.text else { return }
        
        if textField == durationInput, let value = extractFloat(from: string) {
            mini.displayItem.duration = value
            print("Tween Duration Change: ", value)
        }
        
        if textField == repeatCountInput, let value = extractInt(from: string) {
            mini.displayItem.repeatCount = value
            print("Tween RepeatCount Change: ", value)
        }
        
    }
    
}
